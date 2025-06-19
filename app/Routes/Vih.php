<?php

// use Slim\App;

use Slim\Routing\RouteCollectorProxy;

// Controllers
use App\Middleware\PermissionMiddleware;
use App\Controllers\Vih\CuestionariosController;
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
        $group->get('', CuestionariosController::class . ':index');
        $group->post('', CuestionariosController::class . ':list');
        $group->post('/save', CuestionariosController::class . ':store');
        $group->post('/update', CuestionariosController::class . ':update');
        $group->post('/search', CuestionariosController::class . ':search');
        $group->post('/delete', CuestionariosController::class . ':delete');
    })->add(PermissionMiddleware::class);
})->add(new LoginAdminMiddleware());
