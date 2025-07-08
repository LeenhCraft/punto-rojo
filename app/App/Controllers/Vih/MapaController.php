<?php

namespace App\Controllers\Vih;

use App\Core\Controller;
use App\Models\TableModel;
use Exception;

class MapaController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request, $response, $args)
    {
        $model = new TableModel();
        $model->setTable("vih_predicciones a");
        $model->setId("id_prediccion_modelo");
        $historial = $model
            ->select(
                "a.id_prediccion_modelo",
                "a.codigo_prediccion",
                "a.fecha_prediccion",
                "a.casos_predichos",
                "a.horizonte_prediccion_meses"
            )
            ->join("vih_modelo_prediccion_distrito b", "b.id_modelo", "a.id_modelo")
            ->orderBy("a.fecha_prediccion", "DESC")
            ->get();
        return $this->render($response, "Vih.Mapa", [
            "titulo_web" => "Mapa de Predicciones de VIH",
            "url" => $request->getUri()->getPath(),
            "css" => [
                "/css/vih/mapa.css?v=" . time(),
                "https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css",
                "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.css",
                "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"
            ],
            "js" => [
                "https://cdnjs.cloudflare.com/ajax/libs/leaflet.heat/0.2.0/leaflet-heat.js",
                "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.js",
                "/js/vih/mapa.js?v=" . time(),
            ],
            "predicciones" => $historial
        ]);
    }

    public function getPredictions($request, $response, $args)
    {
        try {
            $data = $request->getParsedBody();

            // Validar datos requeridos
            if (!isset($data['fecha_inicio']) || !isset($data['fecha_fin']) || !isset($data['id_prediccion'])) {
                return $this->respondWithJson($response, [
                    'status' => false,
                    'message' => 'Faltan parámetros requeridos'
                ], 400);
            }

            $fechaInicio = $data['fecha_inicio'];
            $fechaFin = $data['fecha_fin'];
            $idPrediccion = $data['id_prediccion'];

            // Obtener casos actuales por distrito en el rango de fechas
            $casosActuales = $this->getCasosActualesPorDistrito($fechaInicio, $fechaFin);

            // Obtener predicciones específicas
            $predicciones = $this->getPrediccionesPorModelo($idPrediccion, $fechaInicio, $fechaFin);

            // Obtener centros de salud con coordenadas
            $centrosSalud = $this->getCentrosSaludConCoordenadas();

            // Combinar datos
            $datosCompletos = $this->combinarDatosParaMapa($casosActuales, $predicciones, $centrosSalud);

            return $this->respondWithJson($response, [
                'status' => true,
                'message' => 'Datos obtenidos correctamente',
                'data' => [
                    'casos_actuales' => $casosActuales,
                    'predicciones' => $predicciones,
                    'centros_salud' => $datosCompletos,
                    'resumen' => [
                        'total_casos_actuales' => array_sum(array_column($casosActuales, 'total_cuestionarios')),
                        'total_casos_predichos' => array_sum(array_column($predicciones, 'casos_predichos')),
                        'total_casos_completados' => array_sum(array_column($casosActuales, 'casos_completados')),
                        'periodo' => [
                            'inicio' => $fechaInicio,
                            'fin' => $fechaFin
                        ]
                    ]
                ]
            ]);
        } catch (Exception $e) {
            return $this->respondWithJson($response, [
                'status' => false,
                'message' => $e->getMessage()
            ]);
        }
    }

    private function getCasosActualesPorDistrito($fechaInicio, $fechaFin)
    {
        $model = new TableModel();
        $model->setTable("vih_cuestionario_vih a");
        $model->setId("id_cuestionario");

        return $model->query(
            "SELECT 
                c.id_distrito,
                d.nombre_distrito,
                COUNT(a.id_cuestionario) as total_cuestionarios,
                SUM(CASE WHEN a.estado = 'completo' THEN 1 ELSE 0 END) as casos_completados,
                SUM(CASE WHEN a.estado = 'pendiente' THEN 1 ELSE 0 END) as casos_pendientes,
                SUM(CASE WHEN a.estado = 'en_proceso' THEN 1 ELSE 0 END) as casos_en_proceso
            FROM vih_cuestionario_vih a
            JOIN vih_establecimiento_salud c ON c.id_establecimiento = a.id_establecimiento
            JOIN vih_distrito d ON d.id_distrito = c.id_distrito
            WHERE a.fecha_aplicacion >= ?
            AND a.fecha_aplicacion <= ?
            GROUP BY c.id_distrito, d.nombre_distrito",
            [
                $fechaInicio,
                $fechaFin
            ]
        )
            ->get();
    }

    private function getPrediccionesPorModelo($idPrediccion, $fechaInicio, $fechaFin)
    {
        $model = new TableModel();
        $model->setTable("vih_prediccion_casos_distrito a");
        $model->setId("id_prediccion");

        $fechaInicioObj = new \DateTime($fechaInicio);
        $fechaFinObj = new \DateTime($fechaFin);

        return $model
            ->query("SELECT 
                a.id_distrito,
                b.nombre_distrito,
                SUM(a.casos_predichos) as casos_predichos,
                SUM(a.casos_minimos_ic95) as casos_minimos,
                SUM(a.casos_maximos_ic95) as casos_maximos,
                AVG(a.probabilidad_incremento) as probabilidad_incremento_promedio,
                GROUP_CONCAT(DISTINCT a.nivel_alerta) as niveles_alerta
            FROM vih_prediccion_casos_distrito a
            JOIN vih_distrito b ON b.id_distrito = a.id_distrito
            WHERE a.id_prediccion_modelo = ?
            AND a.anio_prediccion >= ?
            AND a.anio_prediccion <= ?
            AND a.mes_prediccion >= ?
            AND a.mes_prediccion <= ?
            GROUP BY a.id_distrito, b.nombre_distrito;", [
                $idPrediccion,
                $fechaInicioObj->format('Y'),
                $fechaFinObj->format('Y'),
                $fechaInicioObj->format('m'),
                $fechaFinObj->format('m')
            ])
            ->get();
    }

    private function getCentrosSaludConCoordenadas()
    {
        // Coordenadas de ejemplo para los centros de salud en Moyobamba
        // En producción, estas coordenadas deberían estar en la base de datos
        $coordenadas = [
            'hospital_moyobamba' => [-6.041388710814162, -76.97079533836434],
            'ps_tahuishco' => [-6.02290566461403, -76.96637396559818],
            'ps_calzada' => [-6.028119896857783, -77.04421335505582],
            'ps_san_marcos' => [-6.136338867363455, -77.10395937169797],
            'cs_habana' => [-6.080202561927132, -77.09008050238509],
            'cs_jepelacio' => [-6.107190046871374, -76.92246071342994]
        ];

        $model = new TableModel();
        $model->setTable("vih_establecimiento_salud a");
        $model->setId("id_establecimiento");

        $centros = $model
            ->select(
                "a.id_establecimiento",
                "a.nombre_establecimiento",
                "a.codigo_establecimiento",
                "a.zona",
                "a.microred",
                "a.direccion",
                "b.nombre_distrito"
            )
            ->join("vih_distrito b", "b.id_distrito", "a.id_distrito")
            ->where("a.activo", "=", 1)
            ->get();

        // Agregar coordenadas a cada centro
        foreach ($centros as &$centro) {
            $nombre = $centro['codigo_establecimiento'];
            if (isset($coordenadas[$nombre])) {
                $centro['coordenadas'] = $coordenadas[$nombre];
            } else {
                // Coordenadas por defecto (centro de Moyobamba)
                $centro['coordenadas'] = [-6.0344, -76.9728];
            }
        }

        return $centros;
    }

    private function combinarDatosParaMapa($casosActuales, $predicciones, $centrosSalud)
    {
        $resultado = [];

        foreach ($centrosSalud as $centro) {
            // Buscar casos actuales para el distrito del centro
            $casosDistrito = array_filter($casosActuales, function ($caso) use ($centro) {
                return isset($caso['nombre_distrito']) && $caso['nombre_distrito'] === $centro['nombre_distrito'];
            });

            // Buscar predicciones para el distrito del centro
            $prediccionesDistrito = array_filter($predicciones, function ($prediccion) use ($centro) {
                return isset($prediccion['nombre_distrito']) && $prediccion['nombre_distrito'] === $centro['nombre_distrito'];
            });

            $casosActualesTotal = !empty($casosDistrito) ? array_values($casosDistrito)[0]['total_cuestionarios'] : 0;
            $casosPredichos = !empty($prediccionesDistrito) ? array_values($prediccionesDistrito)[0]['casos_predichos'] : 0;

            $resultado[] = [
                'id' => $centro['id_establecimiento'],
                'name' => $centro['nombre_establecimiento'],
                'coords' => $centro['coordenadas'],
                'currentCases' => (int)$casosActualesTotal,
                'predictedCases' => (int)$casosPredichos,
                'address' => $centro['direccion'],
                'type' => $this->determinarTipoEstablecimiento($centro['nombre_establecimiento']),
                'distrito' => $centro['nombre_distrito'],
                'zona' => $centro['zona'],
                'microred' => $centro['microred'],
                'casos_completados' => !empty($casosDistrito) ? array_values($casosDistrito)[0]['casos_completados'] : 0,
                'casos_pendientes' => !empty($casosDistrito) ? array_values($casosDistrito)[0]['casos_pendientes'] : 0
            ];
        }

        return $resultado;
    }

    private function determinarTipoEstablecimiento($nombre)
    {
        if (strpos(strtolower($nombre), 'hospital') !== false) {
            return 'Hospital';
        } elseif (strpos(strtolower($nombre), 'centro') !== false) {
            return 'Centro de Salud';
        } elseif (strpos(strtolower($nombre), 'puesto') !== false) {
            return 'Puesto de Salud';
        }
        return 'Establecimiento de Salud';
    }
}
