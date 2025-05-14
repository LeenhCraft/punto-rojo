<?php

// use Slim\App;

use App\Controllers\Admin\BuscarDocController;
use Slim\Routing\RouteCollectorProxy;

// Controllers
use App\Controllers\Login\LoginController;
// Middlewares
use App\Middleware\AdminMiddleware;

$app->get('/', LoginController::class . ':index')->add(new AdminMiddleware);

$app->group('/doc', function (RouteCollectorProxy $doc) {
    $doc->get('/dni/{dni}', BuscarDocController::class . ':buscarDni');
    $doc->get('/ruc/{ruc}', BuscarDocController::class . ':buscarRuc');
});
