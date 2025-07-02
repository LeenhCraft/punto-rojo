<?php

namespace App\Controllers\Vih;

use App\Core\Controller;
use App\Models\CuestionarioVIH;
use Exception;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Reader\Csv;
use PhpOffice\PhpSpreadsheet\Reader\Xls;
use PhpOffice\PhpSpreadsheet\Reader\Xlsx;

class ImportarController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Importar datos desde archivo CSV o Excel
     */
    public function importarDatos($request, $response)
    {
        try {
            // Obtener archivos subidos
            $uploadedFiles = $request->getUploadedFiles();

            if (empty($uploadedFiles['archivoDatos'])) {
                return $this->respondWithJson($response, [
                    "status" => "error",
                    "message" => "No se ha subido ningún archivo.",
                    "data" => null
                ], 400);
            }

            $uploadedFile = $uploadedFiles['archivoDatos'];

            // Validar que se subió correctamente
            if ($uploadedFile->getError() !== UPLOAD_ERR_OK) {
                return $this->respondWithJson($response, [
                    "status" => "error",
                    "message" => "Error al subir el archivo: " . $this->getUploadErrorMessage($uploadedFile->getError()),
                    "data" => null
                ], 400);
            }

            // Validar tipo de archivo
            $allowedTypes = ['text/csv', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'];
            $fileType = $uploadedFile->getClientMediaType();
            $fileName = $uploadedFile->getClientFilename();
            $fileExtension = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));

            if (!in_array($fileType, $allowedTypes) && !in_array($fileExtension, ['csv', 'xls', 'xlsx'])) {
                return $this->respondWithJson($response, [
                    "status" => "error",
                    "message" => "Tipo de archivo no permitido. Solo se aceptan archivos CSV, XLS y XLSX.",
                    "data" => null
                ], 400);
            }

            // Guardar archivo temporalmente
            $uploadDir = './temp/';
            if (!is_dir($uploadDir)) {
                mkdir($uploadDir, 0755, true);
            }

            $tempFileName = uniqid('import_') . '.' . $fileExtension;
            $tempFilePath = $uploadDir . $tempFileName;
            $uploadedFile->moveTo($tempFilePath);

            // Procesar el archivo
            $datosImportados = $this->procesarArchivo($tempFilePath, $fileExtension);

            // Limpiar archivo temporal
            if (file_exists($tempFilePath)) {
                unlink($tempFilePath);
            }

            // Validar datos importados
            if (!$datosImportados['status']) {
                return $this->respondWithJson($response, [
                    "status" => "error",
                    "message" => "El archivo no contiene datos válidos.",
                    "data" => null
                ], 400);
            }

            /* // Validar estructura de datos (opcional)
            $validacion = $this->validarEstructuraDatos($datosImportados);
            if (!$validacion['valido']) {
                return $this->respondWithJson($response, [
                    "status" => "warning",
                    "message" => "Datos importados con advertencias: " . $validacion['mensaje'],
                    "data" => $datosImportados
                ], 200);
            } */

            return $this->respondWithJson($response, [
                "status" => "success",
                "message" => "Datos importados correctamente.",
                "data" => [
                    "resumen" => [
                        "total_filas" => $datosImportados['datos'],
                        "total_columnas" => count($datosImportados['headers']),
                        "archivo_original" => $fileName
                    ],
                    "headers" => $datosImportados['headers'],
                    "datos" => $datosImportados['datos'],
                ]
            ]);
        } catch (Exception $e) {
            return $this->respondWithJson($response, [
                "status" => "error",
                "message" => "Error interno: " . $e->getMessage()
            ]);
        }
    }

    /**
     * Procesar archivo usando PhpSpreadsheet
     */
    private function procesarArchivo($filePath, $extension)
    {
        try {
            // Configurar el lector según el tipo de archivo
            if ($extension === 'csv') {
                $reader = new Csv();
                $reader->setDelimiter(';'); // Configurar delimitador para CSV
            } elseif ($extension === 'xls') {
                $reader = new Xls();
            } elseif ($extension === 'xlsx') {
                $reader = new Xlsx();
            } else {
                $reader = IOFactory::createReaderForFile($filePath);
            }

            // Leer el archivo
            $spreadsheet = $reader->load($filePath);
            $worksheet = $spreadsheet->getActiveSheet();
            $rows = $worksheet->toArray();

            // extraer los encabezados
            $headers = array_shift($rows);
            $headers = array_map(function ($header) {
                return str_replace(' ', '_', strtolower($header));
            }, $headers);
            
            $registros_insertados = 0;
            for ($i = 1; $i < count($rows); $i++) {
                // generar nombres y apellidos al azar
                $nombre_completo = $this->generarNombreCompleto();
                // generar dni al azar de 8 digitos
                $dni = $this->generarDNI();
                // generar fecha de nacimiento al azar entre 1950 y 2000
                $fecha_nacimiento = $this->generarFechaNacimiento();
                // escoger una zona al azar de dos pociones
                $zona = rand(0, 1) ? 'urbana' : 'rural';
                // escoger un centro de salud de 6 al azar [hospital_moyobamba, ps_tahuishco, ps_calzada, ps_san_marcos, cs_habana, cs_jerillo]
                $centro_salud = $this->generarCentroSalud();
                // escoger un sexo al azar de dos opciones
                $sexo = rand(0, 1) ? 'masculino' : 'femenino';
                // la edad se genera a partir del excel, pero el excel retorna un valor en base al rango, de 15 a 29 el valor es 2, 30 a 39 el valor es 1, 40 a 59 el valor es 0
                $edad = $rows[$i][0]; // Asumiendo que la edad está en la primera columna
                if ($edad == 2) {
                    $edad = rand(15, 29);
                } elseif ($edad == 1) {
                    $edad = rand(30, 39);
                } elseif ($edad == 0) {
                    $edad = rand(40, 59);
                }

                // escoger un estado civil al azar de soltero, casado, divorciado, viudo, conviviente
                $estado_civil = $this->generarEstadoCivil();
                // escoger un nivel educativo al azar de primaria, secundaria, superior, posgrado
                $nivel_educativo = $this->generarNivelEducativo();
                // escoger una ocupación al azar de empleado, desempleado, estudiante, jubilado, ama de casa
                $ocupacion = $this->generarOcupacion();
                // generar residencia al azar de dos opciones
                $residencia = $this->generarDireccion();

                // generar fecha de aplicación al azar entre 2020 y 2023
                $fecha_aplicacion = date('Y-m-d', rand(strtotime('2020-01-01'), strtotime('2023-12-31')));

                // preguntas

                // Usa preservativo antes del diagnostico
                // •	Siempre = 0
                // •	A veces = 1
                // •	Nunca = 2
                $p1 = $rows[$i][1];
                if ($p1 == 0) {
                    $p1 = "siempre";
                } elseif ($p1 == 1) {
                    $p1 = "a_veces";
                } elseif ($p1 == 2) {
                    $p1 = "nunca";
                }
                // Ha tenido relaciones sexuales sin protección desde su diagnostico
                // •	No = 0
                // •	Si = 2
                $p2 = $rows[$i][2];
                if ($p2 == 0) {
                    $p2 = "no";
                } elseif ($p2 == 2) {
                    $p2 = "si";
                }

                // Numero estimado de parejas sexuales en el último año
                // •	0 = 0
                // •	1 = 1
                // •	>2 = 2
                $p3 = $rows[$i][3];
                if ($p3 == 0) {
                    $p3 = 0;
                } elseif ($p3 == 1) {
                    $p3 = 1;
                } elseif ($p3 > 2) {
                    $p3 = 2;
                }

                // Ha tenido relaciones con personas del mismo sexo
                // •	No = 0
                // •	Si = 2
                $p4 = $rows[$i][4];
                if ($p4 == 0) {
                    $p4 = "no";
                } elseif ($p4 == 2) {
                    $p4 = "si";
                }

                // Ha usado drogas inyectables
                // •	No = 1
                // •	Si = 2
                $p5 = $rows[$i][5];
                if ($p5 == 1) {
                    $p5 = "no";
                } elseif ($p5 == 2) {
                    $p5 = "si";
                }

                // Recibió trasfusiones en lo últimos 5 años
                // •	No = 0
                // •	Si = 2
                $p6 = $rows[$i][6];
                if ($p6 == 0) {
                    $p6 = "no";
                } elseif ($p6 == 2) {
                    $p6 = "si";
                }

                // Tiene antecedentes de ITS
                // •	No = 0
                // •	Si = 2
                $p7 = $rows[$i][7];
                $its_especificar = "";
                if ($p7 == 0) {
                    $p7 = "no";
                } elseif ($p7 == 2) {
                    $p7 = "si";
                }

                if ($p7 == "si") {
                    $its_especificar = $this->generarITS();
                }

                // generar tipo de diagnostico al azar de 3 opciones
                $tipo_diagnostico = $this->generarTipoDiagnostico();
                $otro_tipo_prueba = "";
                if ($tipo_diagnostico == "otro") {
                    $otro_tipo_prueba = $this->generarOtroTipoPrueba();
                }

                // Recibe tratamiento TAR
                // •	No = 0
                // •	Si = 2
                $p8 = $rows[$i][9];
                if ($p8 == 0) {
                    $p8 = "no";
                } elseif ($p8 == 2) {
                    $p8 = "si";
                }

                // genrar fecha de inicio de TAR al azar entre 2020 y 2023
                $fecha_inicio_tar = null;
                $carga_viral = null;
                $cd4 = null;
                if ($p8 == "si") {
                    $fecha_inicio_tar = date('Y-m-d', rand(strtotime('2020-01-01'), strtotime('2023-12-31')));
                    $carga_viral = rand(100, 1000);
                    $cd4 = rand(200, 1000);
                }


                // Presenta alguna ITS actualmente
                // •	No = 0
                // •	No lo sabe = 1
                // •	Si = 2
                $p9 = $rows[$i][10];
                if ($p9 == 0) {
                    $p9 = "no";
                } elseif ($p9 == 1) {
                    $p9 = "no_sabe";
                } elseif ($p9 == 2) {
                    $p9 = "si";
                }

                // Tiene pareja sexual activa actualmente
                // •	No = 0
                // •	Si = 2
                $p10 = $rows[$i][11];
                if ($p10 == 0) {
                    $p10 = "no";
                } elseif ($p10 == 2) {
                    $p10 = "si";
                }

                // Informa a sus parejas sexuales que tiene VIH
                // •	Nunca = 0
                // •	A veces = 1
                // •	Siempre = 2
                $p11 = $rows[$i][12];
                if ($p11 == 0) {
                    $p11 = "Nunca";
                } elseif ($p11 == 1) {
                    $p11 = "A_veces";
                } elseif ($p11 == 2) {
                    $p11 = "Siempre";
                }

                // Utiliza preservativo actualmente en sus relaciones sexuales
                // •	Nunca = 0
                // •	A veces = 1
                // •	Siempre = 2
                $p12 = $rows[$i][13];
                if ($p12 == 0) {
                    $p12 = "Nunca";
                } elseif ($p12 == 1) {
                    $p12 = "A_veces";
                } elseif ($p12 == 2) {
                    $p12 = "Siempre";
                }

                // Sabe si su pareja se ha realizado la prueba de VIH
                // •	No = 0
                // •	No lo sabe = 1
                // •	Si = 2
                $p13 = $rows[$i][14];
                if ($p13 == 0) {
                    $p13 = "No";
                } elseif ($p13 == 1) {
                    $p13 = "No_sabe";
                } elseif ($p13 == 2) {
                    $p13 = "Si";
                }

                // Agregar fila de datos
                $datosAsociativos = [
                    "activo" => "true",
                    'nombres' => $nombre_completo["nombre"],
                    "apellidos" => $nombre_completo["apellidos"],
                    "numero_documento" => $dni,
                    "tipo_documento" => "DNI",
                    "fecha_nacimiento" => $fecha_nacimiento,
                    "zona" => $zona,
                    "establecimiento" => $centro_salud,
                    'edad' => $edad,
                    'sexo' => $sexo,
                    'estado_civil' => $estado_civil,
                    'nivel_educativo' => $nivel_educativo,
                    'ocupacion' => $ocupacion,
                    'residencia' => $residencia,
                    'fecha_diagnostico' => $fecha_aplicacion,
                    'tipo_prueba' => $tipo_diagnostico,
                    'otro_tipo_prueba' => $otro_tipo_prueba,
                    'preservativos_antes' => $p1,
                    'relaciones_sin_proteccion' => $p2,
                    'parejas_sexuales' => $p3,
                    'mismo_sexo' => $p4,
                    'drogas_inyectables' => $p5,
                    'transfusiones' => $p6,
                    'antecedentes_its' => $p7,
                    'its_especificar' => $its_especificar,
                    'tar' => $p8,
                    'fecha_inicio_tar' => $fecha_inicio_tar,
                    'carga_viral' => $carga_viral,
                    'cd4' => $cd4,
                    'its_actual' => $p9,
                    'pareja_activa' => $p10,
                    'informa_parejas' => $p11,
                    'preservativo_actual' => $p12,
                    'pareja_prueba' => $p13
                ];

                try {
                    $modelo = new CuestionarioVIH();
                    $id_personal_medico = 1;

                    $paciente = $modelo->registrarPaciente($datosAsociativos);
                    if (!$paciente) {
                        throw new Exception("Error al registrar el paciente");
                    }

                    $establecimiento = $modelo->obtenerEstablecimiento($datosAsociativos['establecimiento']);
                    if (!$establecimiento) {
                        throw new Exception("Establecimiento de salud no encontrado");
                    }

                    $cuestionario = $modelo->registrarCuestionarioPrincipal(
                        $paciente['id_paciente'],
                        $id_personal_medico,
                        $establecimiento['id_establecimiento']
                    );

                    if (!$cuestionario) {
                        throw new Exception("Error al registrar el cuestionario principal");
                    }

                    $socioDemograficos = $modelo->registrarDatosSociodemograficos($cuestionario['id_cuestionario'], $datosAsociativos);
                    if (!$socioDemograficos) {
                        throw new Exception("Error al registrar los datos sociodemográficos");
                    }

                    $factoresRiesgo = $modelo->registrarFactoresRiesgo($cuestionario['id_cuestionario'], $datosAsociativos);
                    if (!$factoresRiesgo) {
                        throw new Exception("Error al registrar los factores de riesgo");
                    }

                    $informacionClinica = $modelo->registrarInformacionClinica($cuestionario['id_cuestionario'], $datosAsociativos);
                    if (!$informacionClinica) {
                        throw new Exception("Error al registrar la información clínica");
                    }

                    $riesgoTransmision = $modelo->registrarRiesgoTransmision($cuestionario['id_cuestionario'], $datosAsociativos);
                    if (!$riesgoTransmision) {
                        throw new Exception("Error al registrar el riesgo de transmisión");
                    }

                    $registros_insertados++;
                } catch (Exception $e) {
                    throw new Exception("Error al procesar fila {$i}: " . $e->getMessage());
                }
            }

            return [
                "status" => true,
                "headers" => $headers,
                "message" => "Datos importados correctamente, total filas procesadas: {$registros_insertados}",
                "datos" => $registros_insertados
            ];
        } catch (Exception $e) {
            throw new Exception("Error al procesar archivo: " . $e->getMessage());
        }
    }

    private function generarNombreCompleto()
    {
        $nombres = ['Juan', 'María', 'Pedro', 'Ana', 'Luis', 'Laura', 'Carlos', 'Sofía', 'Miguel', 'Isabel'];
        $apellidos = ['García', 'López', 'Martínez', 'Rodríguez', 'Pérez', 'González', 'Fernández', 'Sánchez', 'Ramírez', 'Torres'];
        $nombre = $nombres[array_rand($nombres)];
        $apellido1 = $apellidos[array_rand($apellidos)];
        $apellido2 = $apellidos[array_rand($apellidos)];
        return [
            'nombre' => $nombre,
            'apellidos' => $apellido1 . ' ' . $apellido2
        ];
    }

    private function generarDNI()
    {
        return str_pad(rand(0, 99999999), 8, '0', STR_PAD_LEFT);
    }

    private function generarFechaNacimiento()
    {
        $year = rand(1950, 2000);
        $month = rand(1, 12);
        $day = rand(1, 28); // Para evitar problemas con febrero
        return sprintf('%04d-%02d-%02d', $year, $month, $day);
    }

    private function generarCentroSalud()
    {
        $centros = ['hospital_moyobamba', 'ps_tahuishco', 'ps_calzada', 'ps_san_marcos', 'cs_habana', 'cs_jerillo'];
        return $centros[array_rand($centros)];
    }

    private function generarEstadoCivil()
    {
        $estadosCiviles = ['soltero', 'casado', 'divorciado', 'viudo', 'conviviente'];
        return $estadosCiviles[array_rand($estadosCiviles)];
    }

    private function generarNivelEducativo()
    {
        $nivelesEducativos = ['primaria', 'secundaria', 'superior', 'posgrado'];
        return $nivelesEducativos[array_rand($nivelesEducativos)];
    }

    private function generarOcupacion()
    {
        $ocupaciones = ['empleado', 'desempleado', 'estudiante', 'jubilado', 'ama de casa'];
        return $ocupaciones[array_rand($ocupaciones)];
    }

    private function generarDireccion()
    {
        $direcciones = ['Calle 1', 'Avenida 2', 'Pasaje 3', 'Callejón 4', 'Avenida 5', 'Pasaje 6'];
        $numero = rand(1, 100);
        return $direcciones[array_rand($direcciones)] . ' ' . $numero;
    }

    private function generarTipoDiagnostico()
    {
        $tipos = ['prueba_rapida', 'elisa', 'western_blot', 'otro'];
        return $tipos[array_rand($tipos)];
    }

    private function generarOtroTipoPrueba()
    {
        $otrosTipos = ['PCR', 'Antígeno', 'Anticuerpos'];
        return $otrosTipos[array_rand($otrosTipos)];
    }

    private function generarITS()
    {
        $its = ['gonorrea', 'clamidia', 'sifilis', 'herpes', 'hepatitis'];
        return $its[array_rand($its)];
    }

    /**
     * Validar estructura de datos específica para encuesta VIH
     */
    private function validarEstructuraDatos($datos)
    {
        $camposRequeridos = ['edad', 'preservativos_antes', 'relaciones_sin_proteccion'];
        $camposFaltantes = [];

        foreach ($camposRequeridos as $campo) {
            if (!in_array($campo, $datos['headers'])) {
                $camposFaltantes[] = $campo;
            }
        }

        if (!empty($camposFaltantes)) {
            return [
                'valido' => false,
                'mensaje' => 'Faltan campos requeridos: ' . implode(', ', $camposFaltantes)
            ];
        }

        return ['valido' => true, 'mensaje' => ''];
    }

    /**
     * Limpiar valores individuales
     */
    private function limpiarValor($valor)
    {
        if ($valor === null || $valor === '') {
            return null;
        }

        // Convertir a string y limpiar
        $valor = trim((string)$valor);

        // Si es numérico, convertir
        if (is_numeric($valor)) {
            return (int)$valor;
        }

        return $valor;
    }

    /**
     * Limpiar y mapear headers a nombres más manejables
     */
    private function limpiarHeaders($headers)
    {
        $mapeoHeaders = [
            'Edad' => 'edad',
            '¿Usaba preservativos antes del diagnóstico?' => 'preservativos_antes',
            '¿Ha tenido relaciones sin protección desde su diagnóstico?' => 'relaciones_sin_proteccion',
            'Número de parejas sexuales' => 'num_parejas',
            '¿Ha tenido relaciones con personas del mismo sexo?' => 'relaciones_mismo_sexo',
            '¿Ha usado drogas inyectables?' => 'drogas_inyectables',
            '¿Recibió transfusiones en los últimos 5 años?' => 'transfusiones',
            '¿Tiene antecedentes de ITS?' => 'antecedentes_its',
            '¿Ha tenido relaciones ocasionales desde el diagnóstico?' => 'relaciones_ocasionales',
            '¿Recibe tratamiento TAR?' => 'tratamiento_tar',
            '¿Presenta alguna ITS actualmente?' => 'its_actual',
            '¿Tiene pareja sexual activa?' => 'pareja_activa',
            '¿Informa a sus parejas que tiene VIH?' => 'informa_vih',
            '¿Usa preservativo actualmente?' => 'preservativo_actual',
            '¿Sabe si sus parejas se hicieron prueba VIH?' => 'pareja_prueba_vih'
        ];

        $headersLimpios = [];
        foreach ($headers as $header) {
            $headerLimpio = trim($header);
            $headersLimpios[] = isset($mapeoHeaders[$headerLimpio]) ? $mapeoHeaders[$headerLimpio] :
                strtolower(str_replace(
                    [' ', '¿', '?', 'á', 'é', 'í', 'ó', 'ú', 'ñ'],
                    ['_', '', '', 'a', 'e', 'i', 'o', 'u', 'n'],
                    $headerLimpio
                ));
        }

        return $headersLimpios;
    }

    /**
     * Obtener mensaje de error de upload
     */
    private function getUploadErrorMessage($errorCode)
    {
        $messages = [
            UPLOAD_ERR_INI_SIZE => 'El archivo excede el tamaño máximo permitido.',
            UPLOAD_ERR_FORM_SIZE => 'El archivo excede el tamaño máximo del formulario.',
            UPLOAD_ERR_PARTIAL => 'El archivo se subió parcialmente.',
            UPLOAD_ERR_NO_FILE => 'No se subió ningún archivo.',
            UPLOAD_ERR_NO_TMP_DIR => 'Falta la carpeta temporal.',
            UPLOAD_ERR_CANT_WRITE => 'Error al escribir el archivo.',
            UPLOAD_ERR_EXTENSION => 'Una extensión PHP detuvo la subida.'
        ];

        return isset($messages[$errorCode]) ? $messages[$errorCode] : 'Error desconocido.';
    }
}
