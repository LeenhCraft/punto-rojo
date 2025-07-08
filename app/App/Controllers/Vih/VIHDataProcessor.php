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

            $marcatiempo = date('Y-m-d_H-i-s');
            if (!$outputFile) {
                $outputFile = 'vih_dataset_' . $marcatiempo . '.csv';
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
                $arrConfig["ruta_dataset"] = "../app/XGBoost/Datasets/";
                $textConfig['valor'] = json_encode($arrConfig);
                $this->model->update($textConfig['idconfig'], $textConfig);

                // guardar en datasets
                $modelDataset = new TableModel();
                $modelDataset->setTable('vih_datasets');
                $modelDataset->setId('id_dataset');

                $idDataset = $modelDataset->create([
                    'nombre_dataset' => $outputFile,
                    'ruta_datasets' => $arrConfig["nombre_dataset"],
                    'fecha_generacion' => $marcatiempo,
                    'dataset_activo' => 1,
                ]);

                $modelDataset->query("UPDATE vih_datasets SET dataset_activo = 0 WHERE id_dataset != ?", [$idDataset["id_dataset"]]);

                return [
                    'success' => true,
                    'message' => 'Archivo generado exitosamente',
                    'file_path' => $result,
                    'file_size' => $fileSize,
                    'file_size_kb' => round($fileSize / 1024, 2),
                    'timestamp' => $marcatiempo
                ];
            } else {
                $this->logger->error("Error: El archivo no se generó o está vacío");
                return [
                    'success' => false,
                    'message' => 'El archivo no se generó correctamente o está vacío',
                    'file_path' => $result,
                    'file_exists' => file_exists($result),
                    'file_size' => file_exists($result) ? filesize($result) : 0,
                    'timestamp' => $marcatiempo
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
        try {
            $modelDataset = new TableModel;
            $modelDataset->setTable("vih_configuracion");
            $modelDataset->setId("idconfig");

            $model2 = new TableModel;
            $model2->setTable("vih_configuracion");
            $model2->setId("idconfig");

            $dataset_activo = $modelDataset->query("SELECT * FROM vih_datasets WHERE dataset_activo = 1 ORDER BY fecha_generacion DESC LIMIT 1")->first();

            $this->logger->setLogPath(__DIR__ . '/../../../XGBoost/Logs/trainXGBoostModel_' . date('Y-m-d_H-i-s') . '.log');
            $this->logger->info("Iniciando entrenamiento del modelo XGBoost", [
                'datasetFile' => $datasetFile,
                'pathFile' => $pathFile
            ]);

            // configuraciones
            $textData = $model2->first();
            $configData = json_decode($textData['valor'], true);

            // ruta del csv del dataset
            $ruta_dataset = $configData["nombre_dataset"];

            // rutas para guardar el modelo
            $log = null;
            $marcatiempo = date('Y-m-d_H-i-s');
            // if (!isset($configData["nombre_modelo"]) || empty($configData["nombre_modelo"])) {
            // si esta vacio crear un nombre para el modelo entrenado
            $datasetFile = 'modelo_entrenado_' . $marcatiempo;
            $log = 'log_modelo_entrenado_' . $marcatiempo . '.log';
            // } else {
            //     $datasetFile = $configData["nombre_modelo"] . '_' . $marcatiempo;
            //     $log = 'log_' . $configData["nombre_modelo"] . '_' . $marcatiempo . '.log';
            // }

            // ruta de python
            $pythonPath = $_ENV["PYTHON_PATH"];

            // ruta del archivo Entrenar.py
            $scriptPath = __DIR__ . "/Entrenar.py";

            // parametros de entrada
            $arg = [
                '--data_file' => $ruta_dataset,
                '--model_path' => $pathFile,
                '--model_name' => $datasetFile,
                '--horizon_months' => 6,
                // '--target_column' => '',
                // '--config_file' => '',
                '--output_file' => '../app/XGBoost/Resultados/resultado_' . $datasetFile . '.json',
                // '--predict_only' => '',
                // '--load_model' => '',
                // '--debug' => '',
                '--log_file' => '../app/XGBoost/Logs/' . $log,
                // '--skip-lib-check' => ''
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
            // dep($command, 1);

            // ejecutar el script de python
            $output = [];
            $returnCode = -1;

            // Configurar locale para UTF-8
            setlocale(LC_ALL, 'es_ES.UTF-8');
            putenv('PYTHONIOENCODING=utf-8');

            exec($command, $output, $returnCode);
            // exec($command . " 2>&1", $output, $returnCode);
            // dep([$command, $output, $returnCode], 1);

            // procesar la salida
            if ($returnCode === 0) {
                $result = json_decode(implode("\n", $output), true);

                $this->logger->info("Resultado del entrenamiento del modelo XGBoost", [
                    'result' => $result
                ]);

                if ($result && isset($result['status']) && $result['status']) {
                    $result['dataset_id'] = $dataset_activo['id_dataset'] ?? 0;
                    // === PROCESAR Y REGISTRAR EN BASE DE DATOS ===
                    $registroResult = $this->procesarYRegistrarModelo($result, $datasetFile);

                    if ($registroResult['success']) {
                        $this->logger->info("Modelo registrado exitosamente en base de datos", $registroResult['data']);

                        // Combinar resultado original con información de registro
                        $result['database_info'] = $registroResult['data'];
                        $result['message'] = 'Entrenamiento y registro completados exitosamente';

                        return $result;
                    } else {
                        $this->logger->error("Error registrando modelo en base de datos: " . ($registroResult['message'] ?? 'Error desconocido'));

                        // Retornar resultado original pero con advertencia
                        $result['database_warning'] = $registroResult['message'];
                        $result['message'] = 'Entrenamiento exitoso, pero error en registro de BD';

                        return $result;
                    }
                } else {
                    // Error en el entrenamiento
                    return [
                        'status' => false,
                        'error' => 'Error en el entrenamiento del modelo2',
                        'output' => $result,
                        'return_code' => $returnCode
                    ];
                }
            } else {
                // Manejar error
                return [
                    'status' => false,
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

    /**
     * Procesar la salida del entrenamiento XGBoost y registrar en base de datos
     * 
     * @param array $result Resultado JSON del entrenamiento XGBoost
     * @param string $datasetFile Nombre del archivo del modelo
     * @return array Resultado del procesamiento
     */
    public function procesarYRegistrarModelo($result, $datasetFile)
    {
        try {
            // Verificar que el resultado sea exitoso
            if (!isset($result['status']) || !$result['status']) {
                return [
                    'success' => false,
                    'message' => 'El entrenamiento no fue exitoso',
                    'error' => $result['message'] ?? 'Error desconocido'
                ];
            }

            $this->logger->info("Procesando resultado exitoso del entrenamiento XGBoost");

            // === 1. REGISTRAR INFORMACIÓN DEL MODELO ===
            $modeloId = $this->registrarModelo($result, $datasetFile);

            if (!$modeloId) {
                return [
                    'success' => false,
                    'message' => 'Error al registrar el modelo principal'
                ];
            }

            // === 2. REGISTRAR PREDICCIONES ===
            $prediccionesRegistradas = $this->registrarPredicciones($result, $modeloId);

            // === 3. REGISTRAR REENTRENAMIENTO ===
            $reentrenamientoId = $this->registrarReentrenamiento($result, $modeloId);

            $this->logger->info("Modelo procesado exitosamente", [
                'modelo_id' => $modeloId,
                'predicciones' => count($prediccionesRegistradas),
                'reentrenamiento_id' => $reentrenamientoId
            ]);

            return [
                'success' => true,
                'message' => 'Modelo registrado exitosamente',
                'data' => [
                    'modelo_id' => $modeloId,
                    'predicciones_count' => count($prediccionesRegistradas),
                    'reentrenamiento_id' => $reentrenamientoId,
                    'archivo_modelo' => $result['model_info']['model_file'] ?? null
                ]
            ];
        } catch (Exception $e) {
            $this->logger->error("Error procesando modelo XGBoost", $e);
            return [
                'success' => false,
                'message' => 'Error procesando el modelo: ' . $e->getMessage(),
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Registrar información principal del modelo
     * 
     * @param array $result Resultado del entrenamiento
     * @param string $datasetFile Nombre del archivo
     * @return int|false ID del modelo creado o false
     */
    private function registrarModelo($result, $datasetFile)
    {
        try {
            $model = new TableModel();
            $model->setTable("vih_modelo_prediccion_distrito");
            $model->setId("id_modelo");

            // Extraer información del resultado
            $trainingInfo = $result['training_info'] ?? [];
            $metrics = $result['metrics'] ?? [];
            $config = $trainingInfo['config'] ?? [];
            $params = $trainingInfo['params'] ?? [];

            // Preparar datos para inserción
            $modelData = [
                'id_dataset' => $result['dataset_id'] ?? null,
                'nombre_modelo' => $this->extraerNombreModelo($datasetFile),
                'version_modelo' => $this->extraerVersionModelo($result),
                'algoritmo' => 'XGBoost',
                'parametros_xgboost' => json_encode($params, JSON_UNESCAPED_UNICODE),
                'accuracy' => $metrics['test_r2'] ?? 0,
                'mae_casos' => $metrics['test_mae'] ?? 0,
                'rmse_casos' => $metrics['test_rmse'] ?? 0,
                'mape_porcentual' => $metrics['test_mape'] ?? 0,
                'fecha_entrenamiento' => $this->convertirFechaEntrenamiento($trainingInfo['timestamp'] ?? null),
                'fecha_actualizacion' => date('Y-m-d H:i:s'),
                'modelo_activo' => 1, // Nuevo modelo activo
                'horizonte_prediccion_meses' => $config['horizon_months'] ?? 6,
                'descripcion' => $this->generarDescripcionModelo($result)
            ];

            $this->logger->info("Registrando modelo en base de datos", $modelData);

            // Crear el modelo
            $modeloId = $model->create($modelData);

            if ($modeloId) {
                // Desactivar otros modelos
                $model->query(
                    "UPDATE vih_modelo_prediccion_distrito SET modelo_activo = 0 WHERE id_modelo != ?",
                    [$modeloId["id_modelo"]]
                );

                // actualiza en vih_configuracion la ruta del modelo
                $configModel = new TableModel();
                $configModel->setTable("vih_configuracion");
                $configModel->setId("idconfig");

                $textData = $configModel->first();
                $configData = json_decode($textData['valor'], true);
                $configData["nombre_modelo"] = $datasetFile;
                $configData["ruta_modelo"] = '../app/XGBoost/Modelos/' . $datasetFile;

                $configModel->update(1, [
                    'valor' => json_encode($configData, JSON_UNESCAPED_UNICODE),
                ]);

                $this->logger->info("Modelo registrado con ID: " . $modeloId["id_modelo"]);
                return $modeloId["id_modelo"];
            }

            return false;
        } catch (Exception $e) {
            $this->logger->error("Error registrando modelo principal", $e);
            return false;
        }
    }

    /**
     * Registrar predicciones del modelo
     * 
     * @param array $result Resultado del entrenamiento
     * @param int $modeloId ID del modelo
     * @return array Predicciones registradas
     */
    private function registrarPredicciones($result, $modeloId)
    {
        try {
            $modelo  = new TableModel();
            $modelo->setTable("vih_predicciones");
            $modelo->setId("id_prediccion_modelo");

            $prediccionRq = $modelo->create([
                'id_modelo' => $modeloId,
                'codigo_prediccion' => $modeloId . '-' . date('Ymd-His'),
                'fecha_prediccion' => date('Y-m-d H:i:s'),
                'casos_predichos' => count($result['predictions'] ?? []),
                'horizonte_prediccion_meses' => $result['args']['horizon_months'] ?? 0,
            ]);

            if (!$prediccionRq) {
                $this->logger->error("Error al registrar la predicción del modelo");
                return [];
            }

            $casosPredichos = new TableModel();
            $casosPredichos->setTable("vih_prediccion_casos_distrito");
            $casosPredichos->setId("id_prediccion");

            $predicciones = $result['predictions'] ?? [];
            $prediccionesRegistradas = [];

            $this->logger->info("Registrando " . count($predicciones) . " predicciones");

            foreach ($predicciones as $prediccion) {
                $datosPrediccion = [
                    'id_prediccion_modelo' => $prediccionRq["id_prediccion_modelo"] ?? 0,
                    'id_distrito' => $prediccion['id_distrito'] ?? null,
                    'anio_prediccion' => date('Y', strtotime($prediccion['fecha_prediccion'])),
                    'mes_prediccion' => date('n', strtotime($prediccion['fecha_prediccion'])),
                    'casos_predichos' => round($prediccion['casos_predichos'], 0),
                    'casos_minimos_ic95' => round($prediccion['casos_minimos'], 0),
                    'casos_maximos_ic95' => round($prediccion['casos_maximos'], 0),
                    'probabilidad_incremento' => $this->calcularProbabilidadIncremento($prediccion),
                    'tendencia_esperada' => $this->determinarTendencia($prediccion),
                    'nivel_alerta' => $this->determinarNivelAlerta($prediccion, $result['alerts'] ?? []),
                    'fecha_prediccion' => date('Y-m-d H:i:s'),
                    'factores_influyentes' => $this->extraerFactoresInfluyentes($result)
                ];
                $prediccionId = $casosPredichos->create($datosPrediccion);

                if ($prediccionId) {
                    $prediccionesRegistradas[] = $prediccionId;
                }
            }

            $this->logger->info("Predicciones registradas: " . count($prediccionesRegistradas));
            return $prediccionesRegistradas;
        } catch (Exception $e) {
            $this->logger->error("Error registrando predicciones", $e);
            return [];
        }
    }

    /**
     * Registrar información de reentrenamiento
     * 
     * @param array $result Resultado del entrenamiento
     * @param int $modeloId ID del modelo
     * @return int|false ID del reentrenamiento o false
     */
    private function registrarReentrenamiento($result, $modeloId)
    {
        try {
            $reentrenamientoModel = new TableModel();
            $reentrenamientoModel->setTable("vih_reentrenaminto_modelo");
            $reentrenamientoModel->setId("id_reentrenamiento");

            $trainingInfo = $result['training_info'] ?? [];
            $dataInfo = $result['data_info'] ?? [];
            $metrics = $result['metrics'] ?? [];

            $datosReentrenamiento = [
                'id_modelo' => $modeloId,
                'fecha_reentrenamiento' => date('Y-m-d H:i:s'),
                'motivo_reentrenamiento' => 'Entrenamiento inicial del modelo',
                'registros_entrenamiento' => $trainingInfo['training_samples'] ?? 0,
                'meses_datos_utilizados' => $dataInfo['date_range']['months'] ?? 0,
                'mejora_accuracy' => $metrics['test_r2'] ?? 0,
                'cambios_hiperparametros' => json_encode($trainingInfo['params'] ?? [], JSON_UNESCAPED_UNICODE),
                'reentrenamiento_exitoso' => 1
            ];

            $reentrenamientoId = $reentrenamientoModel->create($datosReentrenamiento);

            if ($reentrenamientoId) {
                $this->logger->info("Reentrenamiento registrado con ID: " . $reentrenamientoId["id_reentrenamiento"]);
            }

            return $reentrenamientoId["id_reentrenamiento"];
        } catch (Exception $e) {
            $this->logger->error("Error registrando reentrenamiento", $e);
            return false;
        }
    }

    /**
     * Extraer nombre del modelo
     */
    private function extraerNombreModelo($datasetFile)
    {
        return pathinfo($datasetFile, PATHINFO_FILENAME) ?: 'Modelo XGBoost VIH';
    }

    /**
     * Extraer versión del modelo
     */
    private function extraerVersionModelo($result)
    {
        $timestamp = $result['timestamp'] ?? date('Y-m-d H:i:s');
        return 'v' . date('Y.m.d.H.i', strtotime($timestamp));
    }

    /**
     * Convertir fecha de entrenamiento
     */
    private function convertirFechaEntrenamiento($timestamp)
    {
        if (!$timestamp) {
            return date('Y-m-d H:i:s');
        }

        try {
            return date('Y-m-d H:i:s', strtotime($timestamp));
        } catch (Exception $e) {
            return date('Y-m-d H:i:s');
        }
    }

    /**
     * Generar descripción del modelo
     */
    private function generarDescripcionModelo($result)
    {
        $dataInfo = $result['data_info'] ?? [];
        $metrics = $result['metrics'] ?? [];

        $descripcion = sprintf(
            "Modelo XGBoost entrenado con %d registros de %d distritos y %d establecimientos. " .
                "Precisión R²: %.2f%%, Error MAPE: %.2f%%. " .
                "Período de datos: %s a %s.",
            $dataInfo['total_records'] ?? 0,
            $dataInfo['districts'] ?? 0,
            $dataInfo['establishments'] ?? 0,
            ($metrics['test_r2'] ?? 0) * 100,
            $metrics['test_mape'] ?? 0,
            $dataInfo['date_range']['start'] ?? 'N/A',
            $dataInfo['date_range']['end'] ?? 'N/A'
        );

        return $descripcion;
    }


    /**
     * Calcular probabilidad de incremento
     */
    private function calcularProbabilidadIncremento($prediccion)
    {
        // Calcular basado en la diferencia entre predicho y mínimo
        $predicho = $prediccion['casos_predichos'] ?? 1;
        $minimo = $prediccion['casos_minimos'] ?? 1;
        $maximo = $prediccion['casos_maximos'] ?? 2;

        if ($maximo <= $minimo) return 0;

        $probabilidad = (($predicho - $minimo) / ($maximo - $minimo)) * 100;
        return max(0, min(100, $probabilidad));
    }

    /**
     * Determinar tendencia esperada
     */
    private function determinarTendencia($prediccion)
    {
        $predicho = $prediccion['casos_predichos'] ?? 1;
        $minimo = $prediccion['casos_minimos'] ?? 1;
        $maximo = $prediccion['casos_maximos'] ?? 2;

        $rango = $maximo - $minimo;

        if ($rango <= 0.5) {
            return 'estable';
        } elseif ($predicho > ($minimo + $rango * 0.7)) {
            return 'ascendente';
        } elseif ($predicho < ($minimo + $rango * 0.3)) {
            return 'descendente';
        } else {
            return 'variable';
        }
    }

    /**
     * Determinar nivel de alerta
     */
    private function determinarNivelAlerta($prediccion, $alerts)
    {
        $idDistrito = $prediccion['id_distrito'] ?? null;
        $fechaPrediccion = $prediccion['fecha_prediccion'] ?? null;

        // Buscar alerta correspondiente
        foreach ($alerts as $alert) {
            if (
                $alert['id_distrito'] == $idDistrito &&
                $alert['fecha_prediccion'] == $fechaPrediccion
            ) {
                return $alert['alert_level'] ?? 'normal';
            }
        }

        // Determinar por casos predichos
        $casos = $prediccion['casos_predichos'] ?? 1;

        if ($casos >= 4) return 'critico';
        if ($casos >= 3) return 'alto';
        if ($casos >= 2) return 'medio';
        return 'bajo';
    }

    /**
     * Extraer factores influyentes
     */
    private function extraerFactoresInfluyentes($result)
    {
        $featureImportance = $result['feature_importance'] ?? [];

        // Tomar las 5 características más importantes
        $topFeatures = array_slice($featureImportance, 0, 5);

        $factores = array_map(function ($feature) {
            return $feature['feature'] . ' (' . round($feature['importance_pct'], 1) . '%)';
        }, $topFeatures);

        return implode(', ', $factores);
    }

    // Método más directo para tu caso
    private function simpleExecToJson($output)
    {
        $jsonString = implode("", $output);

        // Probar decodificación directa
        $result = json_decode($jsonString, true);
        if (json_last_error() === JSON_ERROR_NONE) {
            return $result;
        }

        /* // Arreglar encoding y reintentar
        $cleanedString = mb_convert_encoding($jsonString, 'UTF-8', 'auto');
        $result = json_decode($cleanedString, true);
        if (json_last_error() === JSON_ERROR_NONE) {
            return $result;
        }*/

        /* // Último intento: reemplazar caracteres problemáticos
        $cleanedString = str_replace('�', 'o', $jsonString);
        return json_decode($cleanedString, true); */
    }

    public function activarModelo($idModelo)
    {
        $model = new TableModel();
        $model->setTable("vih_modelo_prediccion_distrito");
        $model->setId("id_modelo");

        // Desactivar todos los modelos
        $model->query("UPDATE vih_modelo_prediccion_distrito SET modelo_activo = 0");

        // Activar el modelo seleccionado
        $result = $model->update($idModelo, ['modelo_activo' => 1]);

        if ($result) {
            return [
                'success' => true,
                'message' => 'Modelo activado exitosamente',
                'id_modelo' => $idModelo
            ];
        } else {
            return [
                'success' => false,
                'message' => 'Error al activar el modelo'
            ];
        }
    }

    public function predicXGBoostModel($data = [])
    {
        try {
            $model2 = new TableModel;
            $model2->setTable("vih_configuracion");
            $model2->setId("idconfig");

            $this->logger->setLogPath(__DIR__ . '/../../../XGBoost/Logs/predictXGBoostModel_' . date('Y-m-d_H-i-s') . '.log');
            $this->logger->info("Iniciando predicción del modelo XGBoost", [
                'data' => $data
            ]);

            // === OBTENER MODELO ACTIVO ===
            $modeloActivo = $model2->query("SELECT * FROM vih_modelo_prediccion_distrito WHERE modelo_activo = 1 ORDER BY fecha_entrenamiento DESC LIMIT 1")->first();
            if (!$modeloActivo) {
                throw new Exception("No hay un modelo activo para realizar la predicción");
            }

            // === OBTENER CONFIGURACIÓN ===
            $configRecord = $model2->query("SELECT * FROM vih_configuracion WHERE idconfig = '1' LIMIT 1")->first();
            if (!$configRecord) {
                throw new Exception("No se encontró la configuración del sistema");
            }

            $configData = json_decode($configRecord['valor'], true);
            if (!$configData) {
                throw new Exception("Error al decodificar la configuración JSON");
            }

            // === OBTENER DATASET ACTIVO ===
            $datasetActivo = $model2->query("SELECT * FROM vih_datasets WHERE dataset_activo = 1 LIMIT 1")->first();
            if (!$datasetActivo) {
                throw new Exception("No hay datasets disponibles para la predicción");
            }

            // === CONFIGURAR RUTAS Y PARÁMETROS ===
            $marcatiempo = date('Y-m-d_H-i-s');
            $ruta_dataset = $datasetActivo['ruta_datasets'];
            $ruta_modelo = dirname($configData["ruta_modelo"]) . '/' . $modeloActivo['nombre_modelo'] . '.pkl';
            $ruta_prediccion = '../app/XGBoost/Predicciones/prediccion_' . $marcatiempo . '.json';
            $ruta_log = '../app/XGBoost/Logs/prediccion_' . $marcatiempo . '.log';

            // Verificar que el modelo existe
            if (!file_exists($ruta_modelo)) {
                throw new Exception("El archivo del modelo no existe: " . $ruta_modelo);
            }

            // === CONFIGURAR COMANDO PYTHON ===
            $pythonPath = $_ENV["PYTHON_PATH"];
            $scriptPath = __DIR__ . "/Entrenar.py";

            // Parámetros específicos para predicción
            $horizonMonths = isset($data['meses_futuro']) ? (int)$data['meses_futuro'] : $modeloActivo['horizonte_prediccion_meses'];
            // $districtId = isset($data['district_id']) ? (int)$data['district_id'] : null;
            // $establishmentId = isset($data['establishment_id']) ? (int)$data['establishment_id'] : null;

            $arg = [
                '--data_file' => $ruta_dataset,
                '--model_path' => dirname($configData["ruta_modelo"]),
                '--load_model' => $ruta_modelo,
                '--horizon_months' => $horizonMonths,
                '--output_file' => $ruta_prediccion,
                '--log_file' => $ruta_log,
                '--predict_only' => '', // Modo solo predicción
            ];

            // Agregar debug si está habilitado
            if (isset($configData["debug"]) && $configData["debug"]) {
                $arg['--debug'] = '';
            }

            // Construir comando
            $command = sprintf(
                '%s %s %s',
                escapeshellarg($pythonPath),
                escapeshellarg($scriptPath),
                implode(' ', array_map(function ($key, $value) {
                    if ($value === '') {
                        return $key; // Para flags como --debug, --predict_only
                    }
                    return sprintf('%s %s', $key, escapeshellarg($value));
                }, array_keys($arg), $arg))
            );

            $this->logger->info("Ejecutando comando de predicción", ['command' => $command]);

            // === EJECUTAR SCRIPT PYTHON ===
            $output = [];
            $returnCode = -1;

            // Configurar locale para UTF-8
            setlocale(LC_ALL, 'es_ES.UTF-8');
            putenv('PYTHONIOENCODING=utf-8');

            // exec($command . " 2>&1", $output, $returnCode);
            exec($command, $output, $returnCode);
            // dep(['command' => $command, 'output' => $output, 'return_code' => $returnCode], 1);

            // === PROCESAR RESULTADO ===
            if ($returnCode === 0) {
                $outputString = implode("\n", $output);
                $result = json_decode($outputString, true);

                if (!$result) {
                    throw new Exception("Error al decodificar la respuesta JSON del modelo: " . $outputString);
                }

                $this->logger->info("Resultado de la predicción XGBoost", ['result' => $result]);

                if ($result && isset($result['status']) && $result['status']) {
                    // === PROCESAR Y GUARDAR PREDICCIONES EN BD ===
                    $registroResult = $this->procesarYGuardarPredicciones($result, $modeloActivo['id_modelo'], $horizonMonths);

                    if ($registroResult['success']) {
                        $this->logger->info("Predicciones guardadas exitosamente en base de datos", $registroResult['data']);

                        // Combinar resultado original con información de registro
                        $result['database_info'] = $registroResult['data'];
                        $result['message'] = 'Predicción completada y guardada exitosamente';
                        $result['prediction_id'] = $registroResult['data']['id_prediccion'];

                        return $result;
                    } else {
                        $this->logger->error("Error guardando predicciones en base de datos: " . ($registroResult['message'] ?? 'Error desconocido'));

                        // Retornar resultado original pero con advertencia
                        $result['database_warning'] = $registroResult['message'];
                        $result['message'] = 'Predicción exitosa, pero error en guardado de BD';

                        return $result;
                    }
                } else {
                    // Error en la predicción
                    return [
                        'status' => false,
                        'error' => 'Error en la predicción del modelo',
                        'details' => $result['message'] ?? 'Error desconocido',
                        'output' => $result,
                        'return_code' => $returnCode
                    ];
                }
            } else {
                // Manejar error de ejecución
                $errorOutput = implode("\n", $output);
                $this->logger->info("Error ejecutando la predicción XGBoost", [
                    'command' => $command,
                    'output' => $errorOutput,
                    'return_code' => $returnCode
                ]);
                return [
                    'status' => false,
                    'error' => 'Error ejecutando la predicción',
                    'details' => $errorOutput,
                    'return_code' => $returnCode
                ];
            }
        } catch (Exception $e) {
            $this->logger->error("Error en la predicción de casos VIH", $e, [
                'params' => $data
            ]);

            return [
                'status' => false,
                'message' => 'Excepción durante la predicción: ' . $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ];
        }
    }

    /**
     * Procesar y guardar las predicciones en las tablas de base de datos
     */
    private function procesarYGuardarPredicciones($result, $idModelo, $horizonMonths)
    {
        try {
            $model = new TableModel;

            // === CREAR REGISTRO PRINCIPAL DE PREDICCIÓN ===
            $model->setTable("vih_predicciones");
            $model->setId("id_prediccion_modelo");

            $prediccionData = [
                'id_modelo' => $idModelo,
                'codigo_prediccion' => $idModelo . '-' . date('Ymd-His'),
                'fecha_prediccion' => date('Y-m-d H:i:s'),
                'casos_predichos' => count($result['predictions']),
                'horizonte_prediccion_meses' => $horizonMonths,
            ];

            $idPrediccion = $model->create($prediccionData);
            if (!$idPrediccion) {
                throw new Exception("Error al crear el registro principal de predicción");
            }

            // === PROCESAR PREDICCIONES POR DISTRITO ===
            $model = new TableModel;
            $model->setTable("vih_prediccion_casos_distrito");
            $model->setId("id_prediccion");

            $registrosGuardados = 0;
            $errores = [];

            if (isset($result['predictions']) && is_array($result['predictions'])) {
                foreach ($result['predictions'] as $prediccion) {
                    try {
                        // Validar datos requeridos
                        if (!isset($prediccion['id_distrito']) || !isset($prediccion['casos_predichos'])) {
                            $errores[] = "Predicción sin datos requeridos: " . json_encode($prediccion);
                            continue;
                        }

                        // Extraer fecha de predicción
                        $fechaPrediccion = $prediccion['fecha_prediccion'] ?? date('Y-m-d');
                        $fechaParts = explode('-', $fechaPrediccion);
                        $anioPrediccion = (int)$fechaParts[0];
                        $mesPrediccion = (int)$fechaParts[1];

                        // Determinar nivel de alerta basado en casos predichos
                        $casosPredichos = (float)$prediccion['casos_predichos'];
                        $nivelAlerta = $this->determinarNivelAlerta($prediccion, $result['alerts'] ?? []);

                        // Calcular probabilidad de incremento (simplificado)
                        $probabilidadIncremento = min(100.0, max(0.0, ($casosPredichos - 20) / 50 * 100));

                        // Determinar tendencia
                        $tendenciaEsperada = $this->determinarTendencia($prediccion);

                        // Preparar factores influyentes
                        $factoresInfluyentes = json_encode([
                            'casos_minimos' => $prediccion['casos_minimos'] ?? 0,
                            'casos_maximos' => $prediccion['casos_maximos'] ?? 0,
                            'intervalo_confianza' => $prediccion['intervalo_confianza'] ?? '0-0',
                            'mes_adelante' => $prediccion['mes_adelante'] ?? 1
                        ]);

                        $prediccionDistrito = [
                            'id_prediccion_modelo' => $idPrediccion["id_prediccion_modelo"],
                            'id_distrito' => (int)$prediccion['id_distrito'],
                            'anio_prediccion' => $anioPrediccion,
                            'mes_prediccion' => $mesPrediccion,
                            'casos_predichos' => round($casosPredichos),
                            'casos_minimos_ic95' => round((float)($prediccion['casos_minimos'] ?? $casosPredichos * 0.8)),
                            'casos_maximos_ic95' => round((float)($prediccion['casos_maximos'] ?? $casosPredichos * 1.2)),
                            'probabilidad_incremento' => $probabilidadIncremento,
                            'tendencia_esperada' => $tendenciaEsperada,
                            'nivel_alerta' => $nivelAlerta,
                            'fecha_prediccion' => $fechaPrediccion,
                            'factores_influyentes' => $factoresInfluyentes
                        ];

                        $insertResult = $model->create($prediccionDistrito);
                        if ($insertResult) {
                            $registrosGuardados++;
                        } else {
                            $errores[] = "Error insertando predicción para distrito " . $prediccion['id_distrito'];
                        }
                    } catch (Exception $e) {
                        $errores[] = "Error procesando predicción: " . $e->getMessage();
                    }
                }
            }

            // === PROCESAR ALERTAS SI EXISTEN ===
            $alertasGuardadas = 0;
            if (isset($result['alerts']) && is_array($result['alerts'])) {
                // Aquí podrías guardar las alertas en una tabla separada si existe
                $alertasGuardadas = count($result['alerts']);
            }

            // === PROCESAR RANKING DE RIESGO SI EXISTE ===
            $rankingGuardado = 0;
            if (isset($result['risk_ranking']) && is_array($result['risk_ranking'])) {
                // Aquí podrías guardar el ranking en una tabla separada si existe
                $rankingGuardado = count($result['risk_ranking']);
            }

            if ($registrosGuardados > 0) {
                return [
                    'success' => true,
                    'data' => [
                        'id_prediccion' => $idPrediccion,
                        'id_modelo' => $idModelo,
                        'predicciones_guardadas' => $registrosGuardados,
                        'alertas_procesadas' => $alertasGuardadas,
                        'ranking_procesado' => $rankingGuardado,
                        'errores' => $errores,
                        'fecha_guardado' => date('Y-m-d H:i:s')
                    ],
                    'message' => "Predicciones guardadas exitosamente: {$registrosGuardados} registros"
                ];
            } else {
                return [
                    'success' => false,
                    'message' => "No se pudieron guardar las predicciones",
                    'errores' => $errores
                ];
            }
        } catch (Exception $e) {
            return [
                'success' => false,
                'message' => "Error guardando predicciones: " . $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ];
        }
    }
}
