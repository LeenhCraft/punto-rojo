<?php

namespace App\Models;

use Exception;

class CuestionarioVIH extends Model
{
    protected $table = "vih_cuestionario_vih";
    protected $id = "id_cuestionario";

    /**
     * Registra un nuevo cuestionario VIH completo
     * @param array $data Datos del formulario
     * @param int $id_personal_medico ID del personal médico que aplica el cuestionario
     * @return array Resultado del registro
     */
    public function registrarCuestionarioCompleto($data, $id_personal_medico)
    {
        try {
            // Iniciar transacción
            $this->beginTransaction();

            // dep($id_personal_medico);
            // 1. Registrar o buscar paciente
            $paciente = $this->registrarPaciente($data);
            if (!$paciente) {
                throw new Exception("Error al registrar el paciente");
            }
            // dep($paciente);

            // 2. Obtener establecimiento de salud
            $establecimiento = $this->obtenerEstablecimiento($data['establecimiento']);
            if (!$establecimiento) {
                throw new Exception("Establecimiento de salud no encontrado");
            }
            // dep($establecimiento);

            // 3. Registrar cuestionario principal
            $cuestionario = $this->registrarCuestionarioPrincipal(
                $paciente['id_paciente'],
                $id_personal_medico,
                $establecimiento['id_establecimiento']
            );

            if (!$cuestionario) {
                throw new Exception("Error al registrar el cuestionario principal");
            }
            // dep($cuestionario);

            // 4. Registrar datos sociodemográficos
            $socioDemograficos = $this->registrarDatosSociodemograficos($cuestionario['id_cuestionario'], $data);
            if (!$socioDemograficos) {
                throw new Exception("Error al registrar los datos sociodemográficos");
            }
            // dep($socioDemograficos);

            // 5. Registrar factores de riesgo
            $factoresRiesgo = $this->registrarFactoresRiesgo($cuestionario['id_cuestionario'], $data);
            if (!$factoresRiesgo) {
                throw new Exception("Error al registrar los factores de riesgo");
            }
            // dep($factoresRiesgo);
            // 6. Registrar información clínica
            $informacionClinica = $this->registrarInformacionClinica($cuestionario['id_cuestionario'], $data);
            if (!$informacionClinica) {
                throw new Exception("Error al registrar la información clínica");
            }
            // dep($informacionClinica);

            // 7. Registrar riesgo de transmisión
            $riesgoTransmision = $this->registrarRiesgoTransmision($cuestionario['id_cuestionario'], $data);
            if (!$riesgoTransmision) {
                throw new Exception("Error al registrar el riesgo de transmisión");
            }
            // dep($riesgoTransmision,1);

            // Confirmar transacción
            $this->commit();

            return [
                'success' => true,
                'message' => 'Cuestionario registrado exitosamente',
                'data' => [
                    'cuestionario_id' => $cuestionario['id_cuestionario'],
                    'paciente_id' => $paciente['id_paciente'],
                    'numero_cuestionario' => $cuestionario['num_cuestionario']
                ]
            ];
        } catch (Exception $e) {
            // Revertir transacción en caso de error
            $this->rollBack();

            return [
                'success' => false,
                'message' => 'Error al registrar el cuestionario: ' . $e->getMessage(),
                'data' => null
            ];
        }
    }

    /**
     * Registra un nuevo paciente o actualiza uno existente
     */
    public function registrarPaciente($data)
    {
        $pacienteModel = new TableModel();
        $pacienteModel->setTable("vih_paciente");
        $pacienteModel->setId("id_paciente");

        // Buscar si el paciente ya existe por número de documento
        $pacienteExistente = $pacienteModel
            ->where('numero_documento', $data['numero_documento'])
            ->where('tipo_documento', strtoupper($data['tipo_documento']))
            ->first();

        if ($pacienteExistente) {
            // Actualizar datos del paciente existente
            return $pacienteModel->update($pacienteExistente['id_paciente'], [
                'nombre_completo' => ucwords(strtolower($data['nombres'] . ' ' . $data['apellidos'])),
                'fecha_nacimiento' => $data['fecha_nacimiento'],
                'activo' => $data['activo'] === 'true' ? 1 : 0
            ]);
        } else {
            // Crear nuevo paciente
            return $pacienteModel->create([
                'nombre_completo' => ucwords(strtolower($data['nombres'] . ' ' . $data['apellidos'])),
                'numero_documento' => $data['numero_documento'],
                'tipo_documento' => strtoupper($data['tipo_documento']),
                'fecha_nacimiento' => $data['fecha_nacimiento'],
                'fecha_registro' => date('Y-m-d H:i:s'),
                'activo' => $data['activo'] === 'true' ? 1 : 0
            ]);
        }
    }

    /**
     * Obtiene el establecimiento de salud
     */
    public function obtenerEstablecimiento($codigo_establecimiento)
    {
        $establecimientoModel = new TableModel();
        $establecimientoModel->setTable("vih_establecimiento_salud");
        $establecimientoModel->setId("id_establecimiento");

        /* // Mapeo de códigos a nombres (ajustar según tu base de datos)
        $mapeoEstablecimientos = [
            'ps_calzada' => 'P.S. Calzada',
            'hospital_moyobamba' => 'P.S. Moyobamba',
            'ps_habana' => 'P.S. Habana',
            'ps_jepelacio' => 'P.S. Jepelacio',
            'ps_soritor' => 'P.S. Soritor',
            'ps_yantalo' => 'P.S. Yantalo'
        ];

        $nombreEstablecimiento = $mapeoEstablecimientos[$codigo_establecimiento] ?? $codigo_establecimiento; */
        $nombreEstablecimiento = $codigo_establecimiento;

        return $establecimientoModel
            ->where('codigo_establecimiento', 'LIKE', "%{$nombreEstablecimiento}%")
            ->where('activo', 1)
            ->first();
    }

    /**
     * Registra el cuestionario principal
     */
    public function registrarCuestionarioPrincipal($id_paciente, $id_personal_medico, $id_establecimiento)
    {
        // Generar número de cuestionario único
        $numeroQuestionario = $this->generarNumeroQuestionario();
        return $this->create([
            'id_paciente' => $id_paciente,
            'id_personal' => $id_personal_medico,
            'id_establecimiento' => $id_establecimiento,
            'fecha_aplicacion' => date('Y-m-d H:i:s'),
            'num_cuestionario' => $numeroQuestionario,
            'estado' => 'Completo',
            'observaciones_generales' => ''
        ]);
    }

    /**
     * Registra datos sociodemográficos
     */
    public function registrarDatosSociodemograficos($id_cuestionario, $data)
    {
        $sociodemograficoModel = new TableModel();
        $sociodemograficoModel->setTable("vih_datos_sociodemograficos");
        $sociodemograficoModel->setId("id_sociodemografico");

        // Determinar grupo de edad
        // $grupoEdad = $this->determinarGrupoEdad($data['edad']);

        return $sociodemograficoModel->create([
            'id_cuestionario' => $id_cuestionario,
            'edad' => $data['edad'],
            'sexo' => ucfirst($data['sexo']),
            'estado_civil' => ucfirst($data['estado_civil']),
            'nivel_educativo' => ucfirst($data['nivel_educativo']),
            'ocupacion_actual' => $data['ocupacion'],
            'lugar_residencia' => $data['residencia']
        ]);
    }

    /**
     * Registra factores de riesgo
     */
    public function registrarFactoresRiesgo($id_cuestionario, $data)
    {
        $factoresModel = new TableModel();
        $factoresModel->setTable("vih_factores_riesgo");
        $factoresModel->setId("id_factores_riesgo");

        return $factoresModel->create([
            'id_cuestionario' => $id_cuestionario,
            'uso_preservativos_pre_diagnostico' => ucfirst($data['preservativos_antes']),
            'relaciones_sin_proteccion_post_diagnostico' => $data['relaciones_sin_proteccion'] === 'si' ? 2 : 0,
            'numero_parejas_ultimo_anio' => (int)$data['parejas_sexuales'],
            'relaciones_mismo_sexo' => $data['mismo_sexo'] === 'si' ? 2 : 0,
            'uso_drogas_inyectables' => $data['drogas_inyectables'] === 'si' ? 2 : 1,
            'transfusiones_ultimos_5_anios' => $data['transfusiones'] === 'si' ? 2 : 0,
            'antecedentes_its' => $data['antecedentes_its'] === 'si' ? 2 : 0,
            'detalle_its_previas' => $data['its_especificar'] ?? '',
            'relaciones_ocasionales_post_diagnostico' => 0 // Valor por defecto
        ]);
    }

    /**
     * Registra información clínica
     */
    public function registrarInformacionClinica($id_cuestionario, $data)
    {
        $clinicaModel = new TableModel();
        $clinicaModel->setTable("vih_informacion_clinica");
        $clinicaModel->setId("id_clinica");

        return $clinicaModel->create([
            'id_cuestionario' => $id_cuestionario,
            'fecha_diagnostico_vih' => empty($data['fecha_diagnostico']) ? null : $data['fecha_diagnostico'],
            'tipo_prueba_diagnostico' => ucfirst(str_replace('_', ' ', $data['tipo_prueba'])),
            'otro_tipo_prueba' => $data['otro_prueba'] ?? '',
            'recibe_tar' => $data['tar'] === 'si' ? 2 : 0,
            'fecha_inicio_tar' => !empty($data['fecha_inicio_tar']) ? $data['fecha_inicio_tar'] : null,
            'ultimo_cd4' => !empty($data['cd4']) ? (int)$data['cd4'] : 0,
            'unidad_cd4' => 'células/μL',
            'ultima_carga_viral' => !empty($data['carga_viral']) ? (int)$data['carga_viral'] : 0,
            'unidad_carga_viral' => 'copias/mL',
            'presenta_its_actual' => $data['its_actual'] === 'si' ? 2 : ($data['its_actual'] === 'no' ? 0 : 1),
            // tenemos 3 tipos, si, no y no_sabe
            'conoce_its_actual' => $data['its_actual'] === 'si' ? "Si" : ($data['its_actual'] === 'no' ? "No" : "No_sabe")
        ]);
    }

    /**
     * Registra riesgo de transmisión
     */
    public function registrarRiesgoTransmision($id_cuestionario, $data)
    {
        $riesgoModel = new TableModel();
        $riesgoModel->setTable("vih_riesgo_transmision");
        $riesgoModel->setId("id_riesgo");

        return $riesgoModel->create([
            'id_cuestionario' => $id_cuestionario,
            'tiene_pareja_activa' => $data['pareja_activa'] === 'si' ? 2 : 0,
            'informa_estado_vih' => ucfirst($data['informa_parejas']),
            'uso_preservativo_actual' => ucfirst($data['preservativo_actual']),
            'pareja_prueba_vih' => $data['pareja_prueba'] === 'si' ? 'Si_al_menos_una_vez' : ($data['pareja_prueba'] === 'no' ? 'No' : 'No_sabe')
        ]);
    }

    /**
     * Determina el grupo de edad según la edad proporcionada
     */
    public function determinarGrupoEdad($edad)
    {
        $edad = (int)$edad;

        if ($edad >= 15 && $edad <= 29) {
            return '15-29';
        } elseif ($edad >= 30 && $edad <= 39) {
            return '30-39';
        } elseif ($edad >= 40 && $edad <= 59) {
            return '40-59';
        } else {
            return '15-29'; // Valor por defecto
        }
    }

    /**
     * Genera un número único para el cuestionario
     */
    public function generarNumeroQuestionario()
    {
        $prefijo = 'CVIH';
        $timestamp = date('YmdHis');
        $random = str_pad(rand(0, 999), 3, '0', STR_PAD_LEFT);

        return $prefijo . $timestamp . $random;
    }

    /**
     * Obtiene un cuestionario completo con todas sus relaciones
     */
    public function obtenerCuestionarioCompleto($id_cuestionario)
    {
        // Cuestionario principal
        $cuestionario = $this->select(
            'c.*',
            'p.nombres',
            'p.apellidos',
            'p.numero_documento',
            'p.tipo_documento',
            'pm.nombres as medico_nombres',
            'pm.apellidos as medico_apellidos',
            'es.nombre_establecimiento'
        )
            ->join('paciente p', 'p.id_paciente', 'c.id_paciente')
            ->join('personal_medico pm', 'pm.id_personal', 'c.id_personal_medico')
            ->join('establecimiento_salud es', 'es.id_establecimiento', 'c.id_establecimiento')
            ->where('c.id_cuestionario', $id_cuestionario)
            ->first();

        if (!$cuestionario) {
            return null;
        }

        // Obtener datos relacionados
        $sociodemograficos = $this->obtenerDatosSociodemograficos($id_cuestionario);
        $factoresRiesgo = $this->obtenerFactoresRiesgo($id_cuestionario);
        $informacionClinica = $this->obtenerInformacionClinica($id_cuestionario);
        $riesgoTransmision = $this->obtenerRiesgoTransmision($id_cuestionario);

        return [
            'cuestionario' => $cuestionario,
            'sociodemograficos' => $sociodemograficos,
            'factores_riesgo' => $factoresRiesgo,
            'informacion_clinica' => $informacionClinica,
            'riesgo_transmision' => $riesgoTransmision
        ];
    }

    // Métodos auxiliares para obtener datos relacionados
    public function obtenerDatosSociodemograficos($id_cuestionario)
    {
        $model = new Model();
        $model->table = "datos_sociodemograficos";
        return $model->where('id_cuestionario', $id_cuestionario)->first();
    }

    public function obtenerFactoresRiesgo($id_cuestionario)
    {
        $model = new Model();
        $model->table = "factores_riesgo";
        return $model->where('id_cuestionario', $id_cuestionario)->first();
    }

    public function obtenerInformacionClinica($id_cuestionario)
    {
        $model = new Model();
        $model->table = "informacion_clinica";
        return $model->where('id_cuestionario', $id_cuestionario)->first();
    }

    public function obtenerRiesgoTransmision($id_cuestionario)
    {
        $model = new Model();
        $model->table = "riesgo_transmision";
        return $model->where('id_cuestionario', $id_cuestionario)->first();
    }

    /**
     * Lista cuestionarios con paginación
     */
    public function listarCuestionarios($filtros = [])
    {
        $query = $this->select(
            'c.*',
            'p.nombres',
            'p.apellidos',
            'p.numero_documento',
            'pm.nombres as medico_nombres',
            'pm.apellidos as medico_apellidos',
            'es.nombre_establecimiento'
        )
            ->join('paciente p', 'p.id_paciente', 'c.id_paciente')
            ->join('personal_medico pm', 'pm.id_personal', 'c.id_personal_medico')
            ->join('establecimiento_salud es', 'es.id_establecimiento', 'c.id_establecimiento');

        // Aplicar filtros si existen
        if (!empty($filtros['estado'])) {
            $query->where('c.estado', $filtros['estado']);
        }

        if (!empty($filtros['fecha_desde'])) {
            $query->where('DATE(c.fecha_aplicacion)', '>=', $filtros['fecha_desde']);
        }

        if (!empty($filtros['fecha_hasta'])) {
            $query->where('DATE(c.fecha_aplicacion)', '<=', $filtros['fecha_hasta']);
        }

        if (!empty($filtros['establecimiento'])) {
            $query->where('c.id_establecimiento', $filtros['establecimiento']);
        }

        return $query->orderBy('c.fecha_aplicacion', 'DESC')->paginate(15);
    }
}
