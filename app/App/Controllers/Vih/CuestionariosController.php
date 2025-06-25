<?php

namespace App\Controllers\Vih;

use App\Core\Controller;
use App\Core\Logger;
use App\Models\CuestionarioVIH;
use DateTime;
use Exception;

class CuestionariosController extends Controller
{
    private Logger $logger;
    private $cuestionarioModel;

    public function __construct()
    {
        parent::__construct();
        //  Instanciamos y configuramos el logger
        $this->logger = new Logger();
        $this->logger
            ->setLogPath(__DIR__ . '/../../../Logs/cuestionario.log')
            ->setIncludeTrace(false)
            ->setIncludeRequest(true);
        $this->cuestionarioModel = new CuestionarioVIH();
    }

    public function index($request,  $response, $args)
    {
        return $this->render($response, "Vih.Cuestionarios", [
            "titulo_web" => "Cuestionarios",
            "url" => $request->getUri()->getPath(),
            "css" => [
                "/css/vih/cuestionario.css",
            ],
            "js" => [
                "/js/vih/cuestionarios.js?v=" . time(),
            ],
        ]);
    }

    public function store($request, $response, $args)
    {
        $data = $this->sanitize($request->getParsedBody());
        // return $this->respondWithJson($response, ['success' => true, 'data' => $data]);

        $errors = $this->validar($data);
        if (!empty($errors)) {
            $msg = "Verifique los datos ingresados: " . implode(", ", $errors);
            return $this->respondWithError($response, $msg, 422, $errors);
        }

        try {
            // Obtener el ID del personal médico de la sesión o token
            $id_personal_medico = $this->obtenerIdPersonalMedico($request);

            if (!$id_personal_medico) {
                return $this->respondWithError($response, 'Usuario no autorizado para registrar cuestionarios', 401);
            }

            // Registrar el cuestionario completo
            $resultado = $this->cuestionarioModel->registrarCuestionarioCompleto($data, $id_personal_medico);

            if ($resultado['success']) {
                $this->logger->info('Cuestionario VIH creado exitosamente', [
                    'cuestionario_id' => $resultado['data']['cuestionario_id'],
                    'paciente_id' => $resultado['data']['paciente_id'],
                    'personal_medico_id' => $id_personal_medico,
                    'numero_cuestionario' => $resultado['data']['numero_cuestionario']
                ]);

                return $this->respondWithJson($response, [
                    'success' => true,
                    'message' => $resultado['message'],
                    'data' => $resultado['data']
                ], 201);
            } else {
                return $this->respondWithError($response, $resultado['message'], 400);
            }
        } catch (Exception $e) {
            // Log del error
            // error_log("Error al crear cuestionario VIH: " . $e->getMessage());
            $this->logger->error(
                'Error al buscar DNI',
                $e,
                [
                    'params' => $data
                ]
            );

            // Respuesta de error
            return $this->respondWithJson(
                $response,
                ['success' => false, 'message' => 'Error al crear cuestionario VIH. ' . $e->getMessage()],
            );
        }
    }

    private function validar($data)
    {
        $errors = [];

        // 1. VALIDACIONES DE IDENTIFICACIÓN GEOGRÁFICA
        if (empty($data['zona']) || !in_array($data['zona'], ['urbana', 'rural'])) {
            $errors[] = 'Debe seleccionar una zona válida (urbana/rural)';
        }

        $establecimientosValidos = [
            'hospital_moyobamba',
            'ps_tahuishco',
            'ps_calzada',
            'ps_san_marcos',
            'cs_habana',
            'cs_jerillo',
            'otro'
        ];

        if (empty($data['establecimiento']) || !in_array($data['establecimiento'], $establecimientosValidos)) {
            $errors[] = 'Debe seleccionar un establecimiento de salud válido';
        }

        // Validar especificación si seleccionó "otro"
        if (isset($data['establecimiento']) && $data['establecimiento'] === 'otro') {
            if (empty($data['otro_especifique']) || strlen(trim($data['otro_especifique'])) < 3) {
                $errors[] = 'Debe especificar el nombre del establecimiento (mínimo 3 caracteres)';
            }
        }

        // 2. VALIDACIONES DE DATOS SOCIODEMOGRÁFICOS
        if (empty($data['edad']) || !is_numeric($data['edad']) || $data['edad'] < 1 || $data['edad'] > 120) {
            $errors[] = 'La edad debe ser un número entre 1 y 120 años';
        }

        if (empty($data['sexo']) || !in_array($data['sexo'], ['masculino', 'femenino', 'otro'])) {
            $errors[] = 'Debe seleccionar un sexo válido';
        }

        $estadosCiviles = ['soltero', 'casado', 'divorciado', 'viudo', 'conviviente'];
        if (empty($data['estado_civil']) || !in_array($data['estado_civil'], $estadosCiviles)) {
            $errors[] = 'Debe seleccionar un estado civil válido';
        }

        $nivelesEducativos = [
            'ninguno',
            'primaria_incompleta',
            'primaria_completa',
            'secundaria_incompleta',
            'secundaria_completa',
            'tecnico',
            'universitario'
        ];
        if (empty($data['nivel_educativo']) || !in_array($data['nivel_educativo'], $nivelesEducativos)) {
            $errors[] = 'Debe seleccionar un nivel educativo válido';
        }

        if (empty($data['ocupacion']) || strlen(trim($data['ocupacion'])) < 2) {
            $errors[] = 'La ocupación debe tener al menos 2 caracteres';
        }

        if (empty($data['residencia']) || strlen(trim($data['residencia'])) < 2) {
            $errors[] = 'El lugar de residencia debe tener al menos 2 caracteres';
        }

        // 3. VALIDACIONES DE COMPORTAMIENTOS Y FACTORES DE RIESGO
        if (empty($data['preservativos_antes']) || !in_array($data['preservativos_antes'], ['siempre', 'a_veces', 'nunca'])) {
            $errors[] = 'Debe indicar el uso de preservativos antes del diagnóstico';
        }

        if (empty($data['relaciones_sin_proteccion']) || !in_array($data['relaciones_sin_proteccion'], ['si', 'no'])) {
            $errors[] = 'Debe indicar si ha tenido relaciones sin protección';
        }

        if (!isset($data['parejas_sexuales']) || !is_numeric($data['parejas_sexuales']) || $data['parejas_sexuales'] < 0 || $data['parejas_sexuales'] > 999) {
            $errors[] = 'El número de parejas sexuales debe ser un número entre 0 y 999';
        }

        if (empty($data['mismo_sexo']) || !in_array($data['mismo_sexo'], ['si', 'no'])) {
            $errors[] = 'Debe indicar si ha tenido relaciones con personas del mismo sexo';
        }

        if (empty($data['drogas_inyectables']) || !in_array($data['drogas_inyectables'], ['si', 'no'])) {
            $errors[] = 'Debe indicar el uso de drogas inyectables';
        }

        if (empty($data['transfusiones']) || !in_array($data['transfusiones'], ['si', 'no'])) {
            $errors[] = 'Debe indicar si recibió transfusiones';
        }

        if (empty($data['antecedentes_its']) || !in_array($data['antecedentes_its'], ['si', 'no'])) {
            $errors[] = 'Debe indicar antecedentes de ITS';
        }

        // Validar especificación de ITS si respondió "sí"
        if (isset($data['antecedentes_its']) && $data['antecedentes_its'] === 'si') {
            if (empty($data['its_especificar']) || strlen(trim($data['its_especificar'])) < 2) {
                $errors[] = 'Debe especificar el tipo de ITS (mínimo 2 caracteres)';
            }
        }

        // 4. VALIDACIONES DE INFORMACIÓN CLÍNICA
        if (empty($data['fecha_diagnostico'])) {
            $errors[] = 'Debe ingresar la fecha de diagnóstico';
        } else {
            // Validar formato de fecha
            $fecha = DateTime::createFromFormat('Y-m-d', $data['fecha_diagnostico']);
            if (!$fecha || $fecha->format('Y-m-d') !== $data['fecha_diagnostico']) {
                $errors[] = 'La fecha de diagnóstico debe tener el formato YYYY-MM-DD';
            } else {
                // Validar que no sea fecha futura
                $hoy = new DateTime();
                if ($fecha > $hoy) {
                    $errors[] = 'La fecha de diagnóstico no puede ser posterior a la fecha actual';
                }
                // Validar que no sea muy antigua (ej: antes de 1980)
                $fechaMinima = new DateTime('1980-01-01');
                if ($fecha < $fechaMinima) {
                    $errors[] = 'La fecha de diagnóstico no puede ser anterior a 1980';
                }
            }
        }

        $tiposPrueba = ['prueba_rapida', 'elisa', 'western_blot', 'otro'];
        if (empty($data['tipo_prueba']) || !in_array($data['tipo_prueba'], $tiposPrueba)) {
            $errors[] = 'Debe seleccionar un tipo de prueba válido';
        }

        // Validar especificación si seleccionó "otro" tipo de prueba
        if (isset($data['tipo_prueba']) && $data['tipo_prueba'] === 'otro') {
            if (empty($data['otro_prueba']) || strlen(trim($data['otro_prueba'])) < 3) {
                $errors[] = 'Debe especificar el tipo de prueba (mínimo 3 caracteres)';
            }
        }

        if (empty($data['tar']) || !in_array($data['tar'], ['si', 'no'])) {
            $errors[] = 'Debe indicar si recibe tratamiento TAR';
        }

        // Validar fecha de inicio TAR si recibe tratamiento
        if (isset($data['tar']) && $data['tar'] === 'si') {
            if (empty($data['fecha_inicio_tar'])) {
                $errors[] = 'Debe ingresar la fecha de inicio del TAR';
            } else {
                $fechaTar = DateTime::createFromFormat('Y-m-d', $data['fecha_inicio_tar']);
                if (!$fechaTar || $fechaTar->format('Y-m-d') !== $data['fecha_inicio_tar']) {
                    $errors[] = 'La fecha de inicio del TAR debe tener el formato YYYY-MM-DD';
                } else {
                    // Validar que la fecha de TAR no sea anterior al diagnóstico
                    if (!empty($data['fecha_diagnostico'])) {
                        $fechaDiagnostico = DateTime::createFromFormat('Y-m-d', $data['fecha_diagnostico']);
                        if ($fechaDiagnostico && $fechaTar < $fechaDiagnostico) {
                            $errors[] = 'La fecha de inicio del TAR no puede ser anterior al diagnóstico';
                        }
                    }
                    // Validar que no sea fecha futura
                    $hoy = new DateTime();
                    if ($fechaTar > $hoy) {
                        $errors[] = 'La fecha de inicio del TAR no puede ser posterior a la fecha actual';
                    }
                }
            }
        }

        // Validar CD4 si se proporcionó
        if (!empty($data['cd4'])) {
            if (!is_numeric($data['cd4']) || $data['cd4'] < 0 || $data['cd4'] > 5000) {
                $errors[] = 'El conteo de CD4 debe ser un número entre 0 y 5000';
            }
        }

        // Validar carga viral si se proporcionó
        if (!empty($data['carga_viral'])) {
            if (!is_numeric($data['carga_viral']) || $data['carga_viral'] < 0) {
                $errors[] = 'La carga viral debe ser un número mayor o igual a 0';
            }
        }

        if (empty($data['its_actual']) || !in_array($data['its_actual'], ['si', 'no', 'no_sabe'])) {
            $errors[] = 'Debe indicar si presenta ITS actualmente';
        }

        // 5. VALIDACIONES DE RIESGO DE TRANSMISIÓN
        if (empty($data['pareja_activa']) || !in_array($data['pareja_activa'], ['si', 'no'])) {
            $errors[] = 'Debe indicar si tiene pareja sexual activa';
        }

        if (empty($data['informa_parejas']) || !in_array($data['informa_parejas'], ['siempre', 'a_veces', 'nunca'])) {
            $errors[] = 'Debe indicar si informa a sus parejas sobre su estado de VIH';
        }

        if (empty($data['preservativo_actual']) || !in_array($data['preservativo_actual'], ['siempre', 'a_veces', 'nunca'])) {
            $errors[] = 'Debe indicar el uso actual de preservativo';
        }

        if (empty($data['pareja_prueba']) || !in_array($data['pareja_prueba'], ['si', 'no', 'no_sabe'])) {
            $errors[] = 'Debe indicar si su pareja se ha realizado la prueba de VIH';
        }

        return $errors;
    }

    /**
     * Obtiene el ID del personal médico de la sesión o token
     * Ajustar según tu sistema de autenticación
     */
    private function obtenerIdPersonalMedico($request)
    {
        /* // Opción 1: Desde header de autorización (JWT)
        $authHeader = $request->getHeaderLine('Authorization');
        if ($authHeader) {
            // Decodificar JWT y obtener ID del personal médico
            // return $this->obtenerIdDesdeJWT($authHeader);
        }

        // Opción 2: Desde sesión
        if (session_status() === PHP_SESSION_ACTIVE) {
            return $_SESSION['id_personal_medico'] ?? null;
        }

        // Opción 3: Desde parámetro (solo para testing - no recomendado en producción)
        $body = $request->getParsedBody();
        if (isset($body['id_personal_medico'])) {
            return (int)$body['id_personal_medico'];
        }

        // Valor por defecto para testing (remover en producción) */
        return 1;
    }
}
