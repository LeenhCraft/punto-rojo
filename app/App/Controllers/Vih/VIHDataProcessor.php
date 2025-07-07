<?php

namespace App\Controllers\Vih;

use App\Core\Logger;
use App\Models\TableModel;
use Exception;

class VIHDataProcessor
{
    private $model;
    private Logger $logger;

    public function __construct()
    {
        $this->model = new TableModel();
        $this->model->setTable('vih_configuracion');
        $this->model->setId('idconfig');
        $arrConfig = $this->model->first();
        if (empty($arrConfig)) {
            die("No existe una configuración para las rutas de los datos");
        }

        $log_name = 'VDP-' . date('Ymd-His');
        //  Instanciamos y configuramos el logger
        $this->logger = new Logger();
        $this->logger
            ->setLogPath(__DIR__ . '/../../../Logs/' . $log_name . '.log')
            ->setIncludeTrace(false)
            ->setIncludeRequest(true);
    }

    /**
     * Obtener datos agregados por distrito y mes desde cuestionarios
     */
    private function getMonthlyAggregatedData($startDate, $endDate)
    {
        $sql = "
        SELECT 
            d.id_distrito,
            d.nombre_distrito,
            d.distrito_codigo,
            d.poblacion_total,
            d.area_km2,
            e.id_establecimiento,
            e.nombre_establecimiento,
            e.codigo_establecimiento,
            e.zona,
            e.microred,
            YEAR(c.fecha_aplicacion) as anio,
            MONTH(c.fecha_aplicacion) as mes,
            DATE_FORMAT(c.fecha_aplicacion, '%Y-%m-01') as fecha_mes,
            
            -- Conteos principales
            COUNT(DISTINCT c.id_cuestionario) as total_cuestionarios,
            COUNT(DISTINCT c.id_paciente) as pacientes_unicos,
            COUNT(DISTINCT CASE WHEN ic.fecha_diagnostico_vih IS NOT NULL THEN c.id_paciente END) as casos_confirmados_vih,
            
            -- Datos sociodemográficos agregados
            AVG(ds.edad) as edad_promedio,
            COUNT(CASE WHEN ds.sexo = 'Masculino' THEN 1 END) as casos_masculino,
            COUNT(CASE WHEN ds.sexo = 'Femenino' THEN 1 END) as casos_femenino,
            COUNT(CASE WHEN ds.estado_civil = 'Soltero' THEN 1 END) as casos_solteros,
            COUNT(CASE WHEN ds.estado_civil = 'Casado' THEN 1 END) as casos_casados,
            COUNT(CASE WHEN ds.estado_civil = 'Conviviente' THEN 1 END) as casos_convivientes,
            
            -- Educación
            COUNT(CASE WHEN ds.nivel_educativo = 'Sin educación' THEN 1 END) as sin_educacion,
            COUNT(CASE WHEN ds.nivel_educativo = 'Primaria' THEN 1 END) as educacion_primaria,
            COUNT(CASE WHEN ds.nivel_educativo = 'Secundaria' THEN 1 END) as educacion_secundaria,
            COUNT(CASE WHEN ds.nivel_educativo = 'Superior' THEN 1 END) as educacion_superior,
            
            -- Factores de riesgo agregados
            AVG(fr.numero_parejas_ultimo_anio) as promedio_parejas_anio,
            COUNT(CASE WHEN fr.relaciones_sin_proteccion_post_diagnostico = 1 THEN 1 END) as casos_sin_proteccion,
            COUNT(CASE WHEN fr.relaciones_mismo_sexo = 1 THEN 1 END) as casos_mismo_sexo,
            COUNT(CASE WHEN fr.uso_drogas_inyectables = 1 THEN 1 END) as casos_drogas_inyectables,
            COUNT(CASE WHEN fr.antecedentes_its = 1 THEN 1 END) as casos_con_its_previas,
            COUNT(CASE WHEN fr.relaciones_ocasionales_post_diagnostico = 1 THEN 1 END) as casos_relaciones_ocasionales,
            
            -- Información clínica
            COUNT(CASE WHEN ic.recibe_tar = 1 THEN 1 END) as casos_recibe_tar,
            AVG(CASE WHEN ic.ultimo_cd4 > 0 THEN ic.ultimo_cd4 END) as promedio_cd4,
            AVG(CASE WHEN ic.ultima_carga_viral > 0 THEN ic.ultima_carga_viral END) as promedio_carga_viral,
            COUNT(CASE WHEN ic.presenta_its_actual > 0 THEN 1 END) as casos_its_actual,
            
            -- Riesgo de transmisión
            COUNT(CASE WHEN rt.tiene_pareja_activa = 1 THEN 1 END) as casos_pareja_activa,
            COUNT(CASE WHEN rt.uso_preservativo_actual = 'Siempre' THEN 1 END) as uso_preservativo_siempre,
            COUNT(CASE WHEN rt.uso_preservativo_actual = 'A veces' THEN 1 END) as uso_preservativo_aveces,
            COUNT(CASE WHEN rt.uso_preservativo_actual = 'Nunca' THEN 1 END) as uso_preservativo_nunca
            
        FROM vih_cuestionario_vih c
        INNER JOIN vih_establecimiento_salud e ON c.id_establecimiento = e.id_establecimiento
        INNER JOIN vih_distrito d ON e.id_distrito = d.id_distrito
        LEFT JOIN vih_datos_sociodemograficos ds ON c.id_cuestionario = ds.id_cuestionario
        LEFT JOIN vih_factores_riesgo fr ON c.id_cuestionario = fr.id_cuestionario
        LEFT JOIN vih_informacion_clinica ic ON c.id_cuestionario = ic.id_cuestionario
        LEFT JOIN vih_riesgo_transmision rt ON c.id_cuestionario = rt.id_riesgo
        
        WHERE c.fecha_aplicacion BETWEEN ? AND ?
        AND c.estado = 'Completo'
        AND d.activo = 1
        AND e.activo = 1
        
        GROUP BY 
            d.id_distrito, 
            e.id_establecimiento,
            YEAR(c.fecha_aplicacion), 
            MONTH(c.fecha_aplicacion),
            DATE_FORMAT(c.fecha_aplicacion, '%Y-%m-01')
        
        ORDER BY 
            d.id_distrito, 
            e.id_establecimiento,
            anio, 
            mes
        ";

        $stmt = $this->model->query($sql, [
            $startDate,
            $endDate
        ])->get();

        return $stmt;
    }

    /**
     * Enriquecer datos con información demográfica y factores de distrito
     */
    private function enrichWithDistrictData($monthlyData)
    {
        $enrichedData = [];

        foreach ($monthlyData as $row) {
            $districtId = $row['id_distrito'];
            $year = $row['anio'];
            $month = $row['mes'];

            // Obtener datos demográficos del distrito
            $demographics = $this->getDistrictDemographics($districtId, $year, $month);

            // Obtener factores del distrito
            $factors = $this->getDistrictFactors($districtId, $year, $month);

            // Combinar datos
            $enrichedRow = array_merge($row, $demographics, $factors);
            $enrichedData[] = $enrichedRow;
        }

        return $enrichedData;
    }

    /**
     * Crear features temporales y de tendencia
     */
    private function createTemporalFeatures($data)
    {
        // Ordenar datos por distrito, establecimiento y fecha
        usort($data, function ($a, $b) {
            if ($a['id_distrito'] != $b['id_distrito']) {
                return $a['id_distrito'] <=> $b['id_distrito'];
            }
            if ($a['id_establecimiento'] != $b['id_establecimiento']) {
                return $a['id_establecimiento'] <=> $b['id_establecimiento'];
            }
            return strcmp($a['fecha_mes'], $b['fecha_mes']);
        });

        $enhancedData = [];
        $previousData = [];

        foreach ($data as $row) {
            $key = $row['id_distrito'] . '_' . $row['id_establecimiento'];

            // Features temporales básicas
            $row['anio_numeric'] = (int)$row['anio'];
            $row['mes_numeric'] = (int)$row['mes'];
            $row['trimestre'] = ceil($row['mes'] / 3);
            $row['semestre'] = ceil($row['mes'] / 6);
            $row['es_inicio_anio'] = ($row['mes'] <= 3) ? 1 : 0;
            $row['es_fin_anio'] = ($row['mes'] >= 10) ? 1 : 0;

            // Calcular tendencias si hay datos previos
            if (isset($previousData[$key])) {
                $prev = $previousData[$key];

                // Diferencias respecto al mes anterior
                $row['diff_casos_mes_anterior'] = $row['total_cuestionarios'] - $prev['total_cuestionarios'];
                $row['diff_confirmados_mes_anterior'] = $row['casos_confirmados_vih'] - $prev['casos_confirmados_vih'];
                $row['tendencia_casos'] = $row['diff_casos_mes_anterior'] > 0 ? 1 : ($row['diff_casos_mes_anterior'] < 0 ? -1 : 0);

                // Porcentaje de cambio
                $row['pct_cambio_casos'] = $prev['total_cuestionarios'] > 0 ?
                    (($row['total_cuestionarios'] - $prev['total_cuestionarios']) / $prev['total_cuestionarios']) * 100 : 0;
            } else {
                $row['diff_casos_mes_anterior'] = 0;
                $row['diff_confirmados_mes_anterior'] = 0;
                $row['tendencia_casos'] = 0;
                $row['pct_cambio_casos'] = 0;
            }

            // Ratios y proporciones importantes
            $row['tasa_confirmacion'] = $row['total_cuestionarios'] > 0 ?
                ($row['casos_confirmados_vih'] / $row['total_cuestionarios']) * 100 : 0;

            $row['ratio_masculino_femenino'] = $row['casos_femenino'] > 0 ?
                $row['casos_masculino'] / $row['casos_femenino'] : $row['casos_masculino'];

            $row['densidad_poblacional'] = $row['area_km2'] > 0 ?
                $row['poblacion_total'] / $row['area_km2'] : 0;

            $row['casos_por_1000_hab'] = $row['poblacion_total'] > 0 ?
                ($row['total_cuestionarios'] / $row['poblacion_total']) * 1000 : 0;

            // Población total por grupos de edad
            $row['poblacion_15_29_total'] = $row['poblacion_15_29_m'] + $row['poblacion_15_29_f'];
            $row['poblacion_30_39_total'] = $row['poblacion_30_39_m'] + $row['poblacion_30_39_f'];
            $row['poblacion_40_59_total'] = $row['poblacion_40_59_m'] + $row['poblacion_40_59_f'];

            // Índices de riesgo
            $row['indice_riesgo_comportamental'] = $this->calculateBehavioralRiskIndex($row);
            $row['indice_riesgo_demografico'] = $this->calculateDemographicRiskIndex($row);

            $enhancedData[] = $row;
            $previousData[$key] = $row;
        }

        return $enhancedData;
    }

    /**
     * Calcular índice de riesgo comportamental
     */
    private function calculateBehavioralRiskIndex($row)
    {
        $risk = 0;
        $total = $row['total_cuestionarios'];

        if ($total > 0) {
            $risk += ($row['casos_sin_proteccion'] / $total) * 30;
            $risk += ($row['casos_drogas_inyectables'] / $total) * 25;
            $risk += ($row['casos_con_its_previas'] / $total) * 20;
            $risk += ($row['casos_relaciones_ocasionales'] / $total) * 15;
            $risk += ($row['promedio_parejas_anio'] > 2 ? 10 : 0);
        }

        return round($risk, 2);
    }

    /**
     * Calcular índice de riesgo demográfico
     */
    private function calculateDemographicRiskIndex($row)
    {
        $risk = 0;

        $risk += $row['indice_pobreza'] * 0.3;
        $risk += (100 - $row['tasa_alfabetizacion']) * 0.2;
        $risk += (100 - $row['cobertura_preservativos']) * 0.25;
        $risk += (10 - $row['programas_prevencion_activos']) * 2;
        $risk += $row['eventos_riesgos'] * 0.5;

        return round(max(0, $risk), 2);
    }

    /**
     * Obtener datos demográficos del distrito
     */
    private function getDistrictDemographics($districtId, $year, $month)
    {
        $sql = "
        SELECT 
            poblacion_15_29_m,
            poblacion_15_29_f,
            poblacion_30_39_m,
            poblacion_30_39_f,
            poblacion_40_59_m,
            poblacion_40_59_f,
            tasa_alfabetizacion,
            centros_salud_activos
        FROM vih_demograficos_distrito 
        WHERE id_distrito = ?
        AND anio = ?
        AND mes = ?
        ORDER BY fecha_actualizacion DESC
        LIMIT 1
        ";

        $stmt = $this->model->query($sql, [
            $districtId,
            $year,
            $month
        ]);

        $result = $stmt->get();

        // Si no hay datos exactos, buscar el más reciente disponible
        if (!$result) {
            $sql = "
            SELECT 
                poblacion_15_29_m,
                poblacion_15_29_f,
                poblacion_30_39_m,
                poblacion_30_39_f,
                poblacion_40_59_m,
                poblacion_40_59_f,
                tasa_alfabetizacion,
                centros_salud_activos
            FROM vih_demograficos_distrito 
            WHERE id_distrito = ?
            ORDER BY anio DESC, mes DESC
            LIMIT 1
            ";

            $stmt = $this->model->query($sql, [
                $districtId
            ]);
            $result = $stmt->get();
        }

        return $result ?: [
            'poblacion_15_29_m' => 0,
            'poblacion_15_29_f' => 0,
            'poblacion_30_39_m' => 0,
            'poblacion_30_39_f' => 0,
            'poblacion_40_59_m' => 0,
            'poblacion_40_59_f' => 0,
            'tasa_alfabetizacion' => 0,
            'centros_salud_activos' => 0
        ];
    }

    /**
     * Obtener factores del distrito
     */
    private function getDistrictFactors($districtId, $year, $month)
    {
        $sql = "
        SELECT 
            indice_pobreza,
            programas_prevencion_activos,
            campanias_vih_mes,
            cobertura_preservativos,
            eventos_riesgos,
            accesibilidad_servicios
        FROM vih_factores_distrito 
        WHERE id_distrito = ? 
        AND anio = ? 
        AND mes = ?
        ORDER BY fecha_registro DESC
        LIMIT 1
        ";

        $stmt = $this->model->query($sql, [
            $districtId,
            $year,
            $month
        ]);

        $result = $stmt->get();

        // Si no hay datos exactos, buscar el más reciente
        if (!$result) {
            $sql = "
            SELECT 
                indice_pobreza,
                programas_prevencion_activos,
                campanias_vih_mes,
                cobertura_preservativos,
                eventos_riesgos,
                accesibilidad_servicios
            FROM vih_factores_distrito 
            WHERE id_distrito = ?
            ORDER BY anio DESC, mes DESC
            LIMIT 1
            ";

            $stmt = $this->model->query($sql, [
                $districtId
            ]);
            $result = $stmt->get();
        }

        return $result ?: [
            'indice_pobreza' => 0,
            'programas_prevencion_activos' => 0,
            'campanias_vih_mes' => 0,
            'cobertura_preservativos' => 0,
            'eventos_riesgos' => 0,
            'accesibilidad_servicios' => 0
        ];
    }

    /**
     * Validar y limpiar datos
     */
    private function validateAndCleanData($data)
    {
        $cleanData = [];
        $removedCount = 0;

        foreach ($data as $row) {
            // Validaciones básicas
            if (empty($row['id_distrito']) || empty($row['id_establecimiento'])) {
                $removedCount++;
                continue;
            }

            if ($row['anio'] < 2020 || $row['anio'] > date('Y')) {
                $removedCount++;
                continue;
            }

            if ($row['mes'] < 1 || $row['mes'] > 12) {
                $removedCount++;
                continue;
            }

            // Limpiar valores nulos o negativos
            foreach ($row as $key => $value) {
                if (is_numeric($value)) {
                    if ($value < 0 && !in_array($key, ['diff_casos_mes_anterior', 'diff_confirmados_mes_anterior', 'tendencia_casos', 'pct_cambio_casos'])) {
                        $row[$key] = 0;
                    }
                    if (is_null($value)) {
                        $row[$key] = 0;
                    }
                }
            }

            $cleanData[] = $row;
        }

        if ($removedCount > 0) {
            $this->logger->info("Registros removidos por validación: $removedCount\n");
        }

        return $cleanData;
    }

    /**
     * Generar archivo CSV
     */
    private function generateCSV($data, $filename)
    {
        if (empty($data)) {
            throw new Exception("No hay datos para generar el archivo CSV");
        }

        $file = fopen($filename, 'w');
        if (!$file) {
            throw new Exception("No se pudo crear el archivo: $filename");
        }

        // Escribir encabezados
        $headers = array_keys($data[0]);
        fputcsv($file, $headers);

        // Escribir datos
        foreach ($data as $row) {
            fputcsv($file, $row);
        }

        fclose($file);

        $this->logger->info("Archivo generado: $filename\n");
        $this->logger->info("Dimensiones: " . count($data) . " filas x " . count($headers) . " columnas\n");
    }

    /**
     * Mostrar estadísticas del dataset
     */
    private function showDatasetStats($data)
    {
        $arrrayStats = [];
        if (empty($data)) return;

        echo "\n" . str_repeat("=", 50) . "\n";
        echo "📈 ESTADÍSTICAS DEL DATASET GENERADO\n";
        echo str_repeat("=", 50) . "\n";

        $totalRows = count($data);
        $totalColumns = count($data[0]);

        echo "📊 Total de registros: $totalRows\n";
        echo "📋 Total de columnas: $totalColumns\n";

        // Estadísticas de casos
        $totalCuestionarios = array_sum(array_column($data, 'total_cuestionarios'));
        $totalConfirmados = array_sum(array_column($data, 'casos_confirmados_vih'));
        $avgCasosPorMes = $totalCuestionarios / $totalRows;

        echo "🔢 Total cuestionarios: $totalCuestionarios\n";
        echo "✅ Total casos confirmados VIH: $totalConfirmados\n";
        echo "📊 Promedio casos por mes: " . round($avgCasosPorMes, 2) . "\n";

        if ($totalCuestionarios > 0) {
            $tasaConfirmacion = ($totalConfirmados / $totalCuestionarios) * 100;
            echo "🎯 Tasa de confirmación: " . round($tasaConfirmacion, 2) . "%\n";
        }

        // Rango de fechas
        $fechas = array_column($data, 'fecha_mes');
        echo "📅 Rango de fechas: " . min($fechas) . " a " . max($fechas) . "\n";

        // Distritos únicos
        $distritos = array_unique(array_column($data, 'id_distrito'));
        echo "🏘️  Distritos únicos: " . count($distritos) . "\n";

        // Establecimientos únicos
        $establecimientos = array_unique(array_column($data, 'id_establecimiento'));
        echo "🏥 Establecimientos únicos: " . count($establecimientos) . "\n";

        echo str_repeat("=", 50) . "\n";
        $this->logger->info("Dataset listo para entrenamiento XGBoost\n");
        $this->logger->info("Variable objetivo sugerida: 'total_cuestionarios' o 'casos_confirmados_vih'\n");
        $this->logger->info(str_repeat("=", 50) . "\n\n");
    }

    /**
     * Procesar datos y generar dataset para XGBoost
     */
    public function processDataForXGBoost($startDate = null, $endDate = null, $outputFile = 'vih_dataset_xgboost.csv')
    {
        $this->logger->info("Iniciando procesamiento de datos para XGBoost...\n");
        // Establecer fechas por defecto si no se proporcionan
        if (!$startDate) {
            $startDate = date('Y-m-d', strtotime('-36 months')); // 3 años atrás
        }
        if (!$endDate) {
            $endDate = date('Y-m-d');
        }
        $this->logger->info("Procesando datos desde: $startDate hasta: $endDate\n");

        // 1. Obtener datos agregados por distrito y mes
        $monthlyData = $this->getMonthlyAggregatedData($startDate, $endDate);
        $this->logger->info("Datos mensuales obtenidos: " . count($monthlyData) . " registros\n");

        if (empty($monthlyData)) {
            throw new Exception("No se encontraron datos en el rango de fechas especificado");
        }

        // 2. Enriquecer con datos demográficos y factores de distrito
        $enrichedData = $this->enrichWithDistrictData($monthlyData);
        $this->logger->info("Datos enriquecidos con información de distrito\n");

        // 3. Crear features temporales y de tendencia
        $finalData = $this->createTemporalFeatures($enrichedData);
        $this->logger->info("Features temporales creadas\n");

        // 4. Validar y limpiar datos
        $cleanData = $this->validateAndCleanData($finalData);
        $this->logger->info("Datos validados y limpiados: " . count($cleanData) . " registros finales\n");

        // 5. Generar archivo CSV
        $this->generateCSV($cleanData, $outputFile);
        $this->logger->info("Archivo generado: $outputFile\n");

        // 6. Mostrar estadísticas del dataset
        // $this->showDatasetStats($cleanData);

        return $outputFile;
    }

    /**
     * Método público para ejecutar el procesamiento completo
     */
    public function execute($startDate = null, $endDate = null, $outputFile = null)
    {
        try {
            $model = new TableModel();
            $model->setTable('vih_configuracion');
            $model->setId('idconfig');
            $textConfig = $model->first();

            $arrConfig = json_decode($textConfig['valor'], true);

            $this->logger->info("Iniciando procesamiento de datos VIH", [
                'startDate' => $startDate,
                'endDate' => $endDate,
                'outputFile' => $outputFile
            ]);

            if (!$outputFile) {
                $outputFile = 'vih_dataset_' . date('Y-m-d_H-i-s') . '.csv';
            }

            $outputFile = $arrConfig["ruta_dataset"] . $outputFile;

            $result = $this->processDataForXGBoost($startDate, $endDate, $outputFile);
            $this->logger->info("Procesamiento completado exitosamente!");
            $this->logger->info("Archivo generado: $result");
            $this->logger->info("Listo para entrenar modelo XGBoost");

            if (file_exists($result) && filesize($result) > 0) {
                $fileSize = filesize($result);
                $this->logger->info("Procesamiento completado exitosamente!");
                $this->logger->info("Archivo generado: $result");
                $this->logger->info("Tamaño del archivo: " . number_format($fileSize / 1024, 2) . " KB");
                $this->logger->info("Listo para entrenar modelo XGBoost");


                $arrConfig["nombre_dataset"] = $result;
                $arrConfig["ruta_dataset"] = "../app/XGBoost/datasets/";
                $textConfig['valor'] = json_encode($arrConfig);
                $this->model->update($textConfig['idconfig'], $textConfig);

                return [
                    'success' => true,
                    'message' => 'Archivo generado exitosamente',
                    'file_path' => $result,
                    'file_size' => $fileSize,
                    'file_size_kb' => round($fileSize / 1024, 2),
                    'timestamp' => date('Y-m-d H:i:s')
                ];
            } else {
                $this->logger->error("Error: El archivo no se generó o está vacío");
                return [
                    'success' => false,
                    'message' => 'El archivo no se generó correctamente o está vacío',
                    'file_path' => $result,
                    'file_exists' => file_exists($result),
                    'file_size' => file_exists($result) ? filesize($result) : 0,
                    'timestamp' => date('Y-m-d H:i:s')
                ];
            }
        } catch (Exception $e) {
            $this->logger->error("Error en el procesamiento de datos VIH", $e, [
                'params' => [
                    'startDate' => $startDate,
                    'endDate' => $endDate,
                    'outputFile' => $outputFile
                ]
            ]);
            throw $e;
        }
    }

    /**
     * Método para entrenar el modelo XGBoost
     */
    public function trainXGBoostModel($datasetFile = null, $pathFile = null)
    {
        // desde este metodo se consumira el archivo Entrenar.py que esta en la misma carpeta
        // al archivo pasarle le pasamos el path del dataset y el path donde se guardara el modelo entrenado y el nombre del modelo

        try {
            $model2 = new TableModel;
            $model2->setTable("vih_configuracion");
            $model2->setId("idconfig");

            // configuraciones
            $textData = $model2->first();
            $configData = json_decode($textData['valor'], true);

            // ruta del csv del dataset
            $ruta_dataset = $configData["nombre_dataset"];

            // rutas para guardar el modelo
            if (!$datasetFile) {
                // si esta vacio crear un nombre aleatorio
                $datasetFile = 'dataset_' . date('Y-m-d_H-i-s');
            }

            // ruta de python
            $pythonPath = $_ENV["PYTHON_PATH"];

            // ruta del archivo Entrenar.py
            $scriptPath = __DIR__ . "/Entrenar.py";

            // parametros de entrada
            $arg = [
                '--data_file' => $ruta_dataset,
                '--model_path' => $pathFile,
                '--model_name' => $datasetFile,
                '--horizon_months' => 6
            ];
            // agregar el debug
            $debug = $configData["debug"]; // o true para ver logs
            if ($debug) {
                $arg['--debug'] = '';
            }

            // construir el comando para ejecutar el script de python
            $command = sprintf(
                '%s %s %s',
                $pythonPath,
                $scriptPath,
                implode(' ', array_map(function ($key, $value) {
                    return sprintf('%s %s', $key, $value);
                }, array_keys($arg), $arg))
            );

            // ejecutar el script de python
            $output = [];
            $returnCode = -1;

            exec($command, $output, $returnCode);
            dep([$command, $output, $returnCode], 1);

            // procesar la salida
            if ($returnCode === 0) {
                $model = new TableModel;
                $model->setTable("vih_modelo_prediccion_distrito");
                $model->setId("id_modelo");

                $modeloCreado = $model->create([
                    "nombre_modelo" => "",
                    "version_modelo" => "",
                    "algoritmo" => "",
                    "parametros_xgboost" => "",
                    "accuracy" => "",
                    "mae_casos" => "",
                    "rmse_casos" => "",
                    "mape_porcentual" => "",
                    "fecha_entrenamiento" => "",
                    "fecha_actualizacion" => "",
                    "modelo_activo" => "",
                    "horizonte_prediccion_meses" => "",
                    "descripcion" => "",
                ]);

                if ($modeloCreado) {
                    // actualizar el campo modelo_activo de todos menos del modelo $modeloCreado
                    $model->query("UPDATE vih_modelo_prediccion_distrito SET modelo_activo = 0 WHERE id_modelo != ?", [$modeloCreado]);
                }

                return json_decode(implode("\n", $output), true);
            } else {
                // Manejar error
                return [
                    'success' => false,
                    'error' => 'Error ejecutando el entrenamiento',
                    'output' => $output,
                    'return_code' => $returnCode
                ];
            }
        } catch (Exception $e) {
            //throw $th;
            $this->logger->error("Error en el entrenamiento de datos VIH", $e, [
                'params' => [
                    'datasetFile' => $datasetFile,
                    'pathFile' => $pathFile
                ]
            ]);
            throw $e;
        }
    }
}
