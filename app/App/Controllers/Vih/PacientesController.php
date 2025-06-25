<?php

namespace App\Controllers\Vih;

use App\Core\Controller;

class PacientesController extends Controller
{
    public function __construct()
    {
        parent::__construct();
    }

    public function index($request,  $response, $args)
    {
        return $this->render($response, "Vih.Pacientes", [
            "titulo_web" => "Pacientes",
            "url" => $request->getUri()->getPath(),
        ]);
    }
}
