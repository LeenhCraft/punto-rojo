<?php

namespace App\Controllers\Vih;

use App\Core\Controller;

class EntrenarController extends Controller
{
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
}
