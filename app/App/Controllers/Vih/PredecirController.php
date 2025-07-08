<?php

namespace App\Controllers\Vih;

use App\Core\Controller;
use App\Models\TableModel;
use Exception;

class PredecirController extends Controller
{
    private const PREDECIR = "accion.predecir";

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
                "b.nombre_modelo as modelo_ia",
                "a.fecha_prediccion",
                "a.casos_predichos",
                "a.horizonte_prediccion_meses"
            )
            ->join("vih_modelo_prediccion_distrito b", "b.id_modelo", "a.id_modelo")
            ->orderBy("a.fecha_prediccion", "DESC")
            ->get();

        return $this->render($response, "Vih.Predecir", [
            "titulo_web" => "Predicción del Modelo de VIH",
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/vih/predecir.js?v=" . time(),
            ],
            "predicciones" => $historial
        ]);
    }

    public function predecir($request, $response)
    {
        try {
            $this->checkPermission(self::PREDECIR, 'create');
            $data = $this->sanitize($request->getParsedBody());

            $outputFile = null;
            $outputPath = "../app/XGBoost/Modelos/";

            $processor = new VIHDataProcessor();
            $result = $processor->predicXGBoostModel($data);

            if (!$result['status']) {
                throw new Exception($result['message']);
            }

            return $this->respondWithJson($response, [
                'success' => true,
                'message' => 'Modelo entrenado correctamente',
                'data' => $result
            ]);
        } catch (Exception $e) {
            return $this->respondWithJson($response, [
                'success' => false,
                'message' => $e->getMessage()
            ]);
        }
    }
}
