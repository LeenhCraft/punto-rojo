<?php

namespace App\Controllers\Vih;

use App\Core\Controller;

class CuestionariosController extends Controller
{
    public function __construct()
    {
        parent::__construct();
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
                "/js/vih/cuestionarios.js",
            ],
        ]);
    }
}
