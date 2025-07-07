<?php

// use Slim\App;

use Slim\Routing\RouteCollectorProxy;

// Controllers
use App\Middleware\PermissionMiddleware;
use App\Controllers\Vih\CuestionariosController;
use App\Controllers\Vih\EntrenarController;
use App\Controllers\Vih\PacientesController;
use App\Middleware\LoginAdminMiddleware;

$app->group('/admin', function (RouteCollectorProxy $group) {
    $group->group('/pacientes', function (RouteCollectorProxy $group) {
        $group->get('', PacientesController::class . ':index');
        $group->post('', PacientesController::class . ':list');
        $group->post('/save', PacientesController::class . ':store');
        $group->post('/update', PacientesController::class . ':update');
        $group->post('/search', PacientesController::class . ':search');
        $group->post('/delete', PacientesController::class . ':delete');
    })->add(PermissionMiddleware::class);

    $group->group('/cuestionarios', function (RouteCollectorProxy $group) {
        $group->get('', CuestionariosController::class . ':indexLista');
        $group->post('', CuestionariosController::class . ':list');
        $group->get('/nuevo', CuestionariosController::class . ':index');
        $group->post('/nuevo', CuestionariosController::class . ':store');
        $group->get('/search/{id}', CuestionariosController::class . ':search');
        $group->post('/delete', CuestionariosController::class . ':delete');
    })->add(PermissionMiddleware::class);

    $group->group('/entrenamiento', function (RouteCollectorProxy $group) {
        $group->get('', EntrenarController::class . ':index');
        $group->post('', EntrenarController::class . ':entrenamiento');
        $group->post('/preparar', EntrenarController::class . ':prepararDatos');
        $group->post('/importar', EntrenarController::class . ':importarDatos');
    })->add(PermissionMiddleware::class);

})->add(new LoginAdminMiddleware());
