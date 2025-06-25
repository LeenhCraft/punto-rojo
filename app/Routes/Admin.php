<?php

// use Slim\App;

use App\Controllers\Admin\BuscarDocController;
use Slim\Routing\RouteCollectorProxy;

// Controllers
use App\Controllers\Admin\DashboardController;
use App\Controllers\Admin\MenusController;
use App\Controllers\Admin\PermisosController;
use App\Controllers\Admin\PermisosEspecialesController;
use App\Controllers\Admin\PersonasController;
use App\Controllers\Admin\RolesController;
use App\Controllers\Admin\SubMenusController;
use App\Controllers\Admin\UsuariosController;
use App\Controllers\Login\LoginController;
use App\Controllers\Login\LogoutController;

// Middlewares
use App\Middleware\AdminMiddleware;
use App\Middleware\LoginAdminMiddleware;
use App\Middleware\PermisosExtrasMiddleware;
use App\Middleware\PermissionMiddleware;

$app->group('/admin/login', function (RouteCollectorProxy $group) {
    $group->get('', LoginController::class . ':index')->add(new AdminMiddleware);
    $group->post('', LoginController::class . ':store');
});

$app->group('/admin', function (RouteCollectorProxy $group) {
    $group->get("", DashboardController::class . ':index');
    $group->get("/logout", LogoutController::class . ':admin');

    $group->group('/menus', function (RouteCollectorProxy $group) {
        $group->get('', MenusController::class . ':index');
        $group->post('', MenusController::class . ':list');
        $group->post('/save', MenusController::class . ':store');
        $group->post('/update', MenusController::class . ':update');
        $group->post('/search', MenusController::class . ':search');
        $group->post('/delete', MenusController::class . ':delete');
    })->add(PermissionMiddleware::class);

    $group->group('/submenus', function (RouteCollectorProxy $group) {
        $group->get('', SubMenusController::class . ':index');
        $group->post('', SubMenusController::class . ':list');
        $group->post('/save', SubMenusController::class . ':store');
        $group->post('/update', SubMenusController::class . ':update');
        $group->post('/menus', SubMenusController::class . ':menus');
        $group->post('/search', SubMenusController::class . ':search');
        $group->post('/delete', SubMenusController::class . ':delete');
    })->add(PermissionMiddleware::class);

    $group->group('/permisos', function (RouteCollectorProxy $group) {
        $group->get('', PermisosController::class . ':index');
        $group->post('', PermisosController::class . ':list');
        $group->post('/save', PermisosController::class . ':store');
        $group->post('/delete', PermisosController::class . ':delete');
        $group->post('/active', PermisosController::class . ':active');
        $group->post('/roles', PermisosController::class . ':roles');
        $group->post('/menus', PermisosController::class . ':menus');
        $group->post('/submenus', PermisosController::class . ':submenus');
    })->add(PermissionMiddleware::class);

    $group->group('/permisos-especiales', function (RouteCollectorProxy $group) {
        $group->get('', PermisosEspecialesController::class . ':index');
        $group->get('/getroles', PermisosEspecialesController::class . ':getRoles');
        $group->get('/getpermisosporrol/{id}', PermisosEspecialesController::class . ':getPermisosPorRol');

        $group->post('/getrecursos', PermisosEspecialesController::class . ':getRecursos');
        $group->get('/getrecursos', PermisosEspecialesController::class . ':getRecursos');
        $group->get('/recurso/{id}', PermisosEspecialesController::class . ':searchRecurso');
        $group->post('/saverecurso', PermisosEspecialesController::class . ':storeRecurso');
        $group->post('/deleterecurso', PermisosEspecialesController::class . ':deleteRecurso');

        $group->post('/getacciones', PermisosEspecialesController::class . ':getAcciones');
        $group->get('/getacciones', PermisosEspecialesController::class . ':getAcciones');
        $group->get('/accion/{id}', PermisosEspecialesController::class . ':searchAccion');
        $group->post('/saveaccion', PermisosEspecialesController::class . ':storeAccion');
        $group->post('/deleteaccion', PermisosEspecialesController::class . ':deleteAccion');

        $group->post('/savepermiso', PermisosEspecialesController::class . ':storePermiso');
        $group->post('/updatepermiso', PermisosEspecialesController::class . ':updatePermiso');
        $group->post('/deletepermiso', PermisosEspecialesController::class . ':deletePermiso');
    });

    $group->group('/usuarios', function (RouteCollectorProxy $group) {
        $group->get('', UsuariosController::class . ':index');
        $group->post('', UsuariosController::class . ':list');
        $group->post('/save', UsuariosController::class . ':store');
        $group->get('/search/{id}', UsuariosController::class . ':search');
        $group->post('/update/{id}', UsuariosController::class . ':update');
        $group->post('/delete/{id}', UsuariosController::class . ':delete');
        // Endpoint para obtener personal sin usuario
        $group->get('/personal', UsuariosController::class . ':getPersonalSinUsuario');
    })->add(PermissionMiddleware::class);

    $group->group('/personas', function (RouteCollectorProxy $group) {
        $group->get('', PersonasController::class . ':index');
        $group->post('', PersonasController::class . ':list');
        $group->post('/save', PersonasController::class . ':store');
        $group->get('/search/{id}', PersonasController::class . ':search');
        $group->post('/update/{id}', PersonasController::class . ':update');
        $group->post('/delete/{id}', PersonasController::class . ':delete');
        // Endpoints adicionales
        $group->get('/doc/dni/{dni}', PersonasController::class . ':searchByDNI');
    })->add(PermissionMiddleware::class);

    $group->group('/roles', function (RouteCollectorProxy $group) {
        $group->get('', RolesController::class . ':index');
        $group->post('', RolesController::class . ':list');
        $group->post('/save', RolesController::class . ':store');
        $group->get('/search/{id}', RolesController::class . ':search');
        $group->post('/update/{id}', RolesController::class . ':update');
        $group->post('/delete/{id}', RolesController::class . ':delete');
    })->add(PermissionMiddleware::class);

    $group->group('/doc', function (RouteCollectorProxy $group) {
        $group->get('/dni/{dni}', BuscarDocController::class . ':buscarDni');
        $group->get('/ruc/{ruc}', BuscarDocController::class . ':buscarRuc');
    })->add(PermisosExtrasMiddleware::class);
})->add(new LoginAdminMiddleware());
