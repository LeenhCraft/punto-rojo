<?php

namespace App\Controllers\Vih;

use App\Core\Controller;
use DateTime;
use Exception;

class EntrenarController extends Controller
{
    private const DATASET = "accion.preparar.dataset";
    private const ENTRENAR = "accion.entrenar.modelo";

    public function __construct()
    {
        parent::__construct();
    }

    public function index($request,  $response, $args)
    {
        return $this->render($response, "Vih.Entrenar", [
            "titulo_web" => "Entrenamiento del Modelo de VIH",
            "url" => $request->getUri()->getPath(),
            "js" => [
                "/js/vih/entrenar.js?v=" . time(),
            ]
        ]);
    }

    /**
     * Importar datos desde archivo CSV o Excel
     */
    public function importarDatos($request, $response)
    {
        $clase = new ImportarController();
        return $clase->importarDatos($request, $response);
    }

    /**
     * Preparar datos para el entrenamiento del modelo
     */
    public function prepararDatos($request, $response)
    {
        try {
            $this->checkPermission(self::DATASET, 'create');
            $data = $this->sanitize($request->getParsedBody());

            $startDate = $data['fechaInicio'] ?? null;
            $endDate = $data['fechaFin'] ?? null;
            $outputFile = $data['nombreDataset'];


            if ($startDate && !DateTime::createFromFormat('Y-m-d', $startDate)) {
                throw new Exception("Formato de fecha_inicio inválido. Use YYYY-MM-DD");
            }

            if ($endDate && !DateTime::createFromFormat('Y-m-d', $endDate)) {
                throw new Exception("Formato de fecha_fin inválido. Use YYYY-MM-DD");
            }

            // dar el formato Y-m-d H:i:s a la fecha actual
            $startDate = $startDate . ' 00:00:00';
            $endDate = $endDate . ' 23:59:59';

            $processor = new VIHDataProcessor();
            $result = $processor->execute($startDate, $endDate, $outputFile);

            if (!$result['success']) {
                throw new Exception($result['message']);
            }
            return $this->respondWithJson($response, [
                'success' => true,
                'message' => 'Datos procesados correctamente',
                'dataset' => $result['message']
            ]);
        } catch (Exception $e) {
            return $this->respondWithJson($response, [
                'success' => false,
                'message' => $e->getMessage()
            ]);
        }
    }

    /**
     * Entrenar el modelo XGBoost con los datos preparados
     */
    public function entrenamiento($request, $response)
    {
        try {
            $this->checkPermission(self::ENTRENAR, 'create');
            $data = $this->sanitize($request->getParsedBody());

            $outputFile = $data['dataset'] ?? null;
            $outputPath = "../app/XGBoost/Modelos/";

            $processor = new VIHDataProcessor();
            $result = $processor->trainXGBoostModel($outputFile, $outputPath);
            
            dep($result, 1);

            if (!$result['success']) {
                throw new Exception($result['message']);
            }

            return $this->respondWithJson($response, [
                'success' => true,
                'message' => 'Modelo entrenado correctamente',
                'model' => $result['model']
            ]);
        } catch (Exception $e) {
            return $this->respondWithJson($response, [
                'success' => false,
                'message' => $e->getMessage()
            ]);
        }
    }
}
