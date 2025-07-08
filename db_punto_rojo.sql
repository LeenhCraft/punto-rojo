-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 08-07-2025 a las 04:44:01
-- Versión del servidor: 8.0.30
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_punto_rojo`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_acciones`
--

CREATE TABLE `sis_acciones` (
  `idaccion` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `identificador` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_acciones`
--

INSERT INTO `sis_acciones` (`idaccion`, `nombre`, `identificador`, `descripcion`, `estado`) VALUES
(1, 'Crear', 'create', '', 1),
(2, 'Leer', 'read', '', 1),
(3, 'Actualizar', 'update', '', 1),
(4, 'Eliminar', 'delete', '', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_centinela`
--

CREATE TABLE `sis_centinela` (
  `idcentinela` int NOT NULL,
  `codigo` int NOT NULL,
  `ip` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `agente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_menus`
--

CREATE TABLE `sis_menus` (
  `idmenu` int NOT NULL,
  `men_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `men_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `men_controlador` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `men_icono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `men_url_si` tinyint(1) NOT NULL DEFAULT '0',
  `men_orden` int NOT NULL,
  `men_visible` tinyint(1) NOT NULL,
  `men_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_menus`
--

INSERT INTO `sis_menus` (`idmenu`, `men_nombre`, `men_url`, `men_controlador`, `men_icono`, `men_url_si`, `men_orden`, `men_visible`, `men_fecha`) VALUES
(1, 'Maestras', '#', NULL, 'bx bx-lock-open-alt', 0, 100, 1, '2023-03-06 12:39:09'),
(6, 'Modulo Usuario', '#', NULL, 'bx bxs-user-circle bx-sm', 0, 6, 1, '2025-02-18 18:02:04'),
(9, 'Modulo Paciente', '#', NULL, 'bx bx-plus-medical', 0, 3, 1, '2025-06-18 18:53:44'),
(10, 'Modulo Predicción', '#', NULL, 'bx bx-circle', 0, 2, 1, '2025-06-18 19:52:07'),
(11, 'Modulo de Visualización', '#', NULL, 'bx bxs-location-plus', 0, 1, 1, '2025-07-07 19:47:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_permisos`
--

CREATE TABLE `sis_permisos` (
  `idpermisos` int NOT NULL,
  `idrol` int NOT NULL,
  `idsubmenu` int NOT NULL,
  `perm_r` int DEFAULT NULL,
  `perm_w` int DEFAULT NULL,
  `perm_u` int DEFAULT NULL,
  `perm_d` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_permisos`
--

INSERT INTO `sis_permisos` (`idpermisos`, `idrol`, `idsubmenu`, `perm_r`, `perm_w`, `perm_u`, `perm_d`) VALUES
(3, 1, 2, 1, 1, 1, 1),
(4, 1, 3, 1, 1, 1, 1),
(5, 1, 1, 1, 1, 1, 1),
(9, 1, 6, 1, 0, 0, 0),
(12, 1, 9, 1, 0, 0, 0),
(14, 1, 11, 1, 0, 0, 0),
(15, 1, 12, 1, 0, 0, 0),
(21, 1, 18, 1, 0, 0, 0),
(22, 1, 19, 1, 0, 0, 0),
(23, 1, 20, 1, 0, 0, 0),
(24, 1, 21, 1, 0, 0, 0),
(25, 1, 22, 1, 0, 0, 0),
(26, 1, 23, 1, 0, 0, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_permisos_extras`
--

CREATE TABLE `sis_permisos_extras` (
  `idpermiso` int NOT NULL,
  `idrol` int NOT NULL DEFAULT '0',
  `idrecurso` int NOT NULL,
  `idaccion` int NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_permisos_extras`
--

INSERT INTO `sis_permisos_extras` (`idpermiso`, `idrol`, `idrecurso`, `idaccion`, `estado`, `fecha_registro`) VALUES
(1, 1, 1, 2, 1, '2025-05-24 12:06:37'),
(2, 1, 2, 1, 1, '2025-06-18 18:55:14'),
(3, 1, 2, 2, 1, '2025-06-18 18:55:18'),
(4, 1, 2, 3, 1, '2025-06-18 18:55:20'),
(5, 1, 2, 4, 1, '2025-06-18 18:55:24'),
(6, 1, 3, 1, 1, '2025-07-03 19:34:14'),
(7, 1, 3, 2, 1, '2025-07-03 19:34:21'),
(8, 1, 4, 1, 1, '2025-07-06 19:21:27'),
(9, 1, 5, 1, 1, '2025-07-07 15:22:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_personal`
--

CREATE TABLE `sis_personal` (
  `idpersona` int NOT NULL,
  `per_dni` int NOT NULL,
  `per_nombre` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `per_celular` int DEFAULT NULL,
  `per_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `per_direcc` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `per_foto` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `per_estado` tinyint(1) NOT NULL DEFAULT '1',
  `per_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_personal`
--

INSERT INTO `sis_personal` (`idpersona`, `per_dni`, `per_nombre`, `per_celular`, `per_email`, `per_direcc`, `per_foto`, `per_estado`, `per_fecha`) VALUES
(1, 72845692, 'TARRILLO OCAS, JEAN LIU', 950880347, 'jeajjlt@gmail.com', '', NULL, 1, '2022-07-22 01:09:20'),
(2, 76144152, 'BUSTAMANTE FERNANDEZ LEENH ALEXANDER', NULL, 'hackingleenh@gmail.com', NULL, NULL, 1, '2025-03-10 18:12:53');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_recursos`
--

CREATE TABLE `sis_recursos` (
  `idrecurso` int NOT NULL,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `identificador` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_recursos`
--

INSERT INTO `sis_recursos` (`idrecurso`, `nombre`, `descripcion`, `tipo`, `identificador`, `estado`, `fecha_registro`) VALUES
(1, 'Consultar Dni', NULL, 'ruta', 'doc.dni', 1, '2025-05-24 12:06:26'),
(2, 'Pacientes', NULL, 'ruta', 'pacientes', 1, '2025-06-18 18:55:02'),
(3, 'Preparar Datos', NULL, 'accion', 'accion.preparar.dataset', 1, '2025-07-03 19:34:06'),
(4, 'Entrenar Modelo', NULL, 'accion', 'accion.entrenar.modelo', 1, '2025-07-04 00:46:54'),
(5, 'Predecir', NULL, 'accion', 'accion.predecir', 1, '2025-07-07 15:22:18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_rol`
--

CREATE TABLE `sis_rol` (
  `idrol` int NOT NULL,
  `rol_cod` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol_descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol_estado` tinyint(1) NOT NULL,
  `rol_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_rol`
--

INSERT INTO `sis_rol` (`idrol`, `rol_cod`, `rol_nombre`, `rol_descripcion`, `rol_estado`, `rol_fecha`) VALUES
(1, '/', 'developer', NULL, 1, '2022-07-22 01:09:56'),
(2, 'developer', 'Desarrollador del sistema', 'descripción', 0, '2025-02-19 14:35:08'),
(3, 'doc', 'Personal Médico', '', 1, '2025-02-24 16:02:31'),
(4, 'web', 'Usuario Web', '', 1, '2025-02-25 13:46:16');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_server_email`
--

CREATE TABLE `sis_server_email` (
  `idserveremail` int NOT NULL,
  `em_host` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `em_usermail` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `em_pass` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NOT NULL,
  `em_port` int NOT NULL,
  `em_estado` tinyint(1) NOT NULL DEFAULT '1',
  `em_default` tinyint(1) DEFAULT NULL,
  `em_fupdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `em_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Volcado de datos para la tabla `sis_server_email`
--

INSERT INTO `sis_server_email` (`idserveremail`, `em_host`, `em_usermail`, `em_pass`, `em_port`, `em_estado`, `em_default`, `em_fupdate`, `em_fecha`) VALUES
(1, 'mail.leenhcraft.com', 'servicios@leenhcraft.com', 'DJ-leenh-#1', 465, 1, 1, '2022-05-06 22:29:56', '2022-03-19 23:12:56'),
(2, 'smtp.gmail.com', '2018100486facke@gmail.com', 'bteaasmagqeaiyax', 465, 1, 0, '2022-03-19 23:25:14', '2022-03-19 23:25:14');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_sesiones`
--

CREATE TABLE `sis_sesiones` (
  `idsesion` int NOT NULL,
  `idusuario` int NOT NULL,
  `session_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tiempo_expiracion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_sesiones`
--

INSERT INTO `sis_sesiones` (`idsesion`, `idusuario`, `session_token`, `ip`, `fecha_registro`, `tiempo_expiracion`, `activo`) VALUES
(1, 1, 'c36939088f5e7f63b3b890e4344f153a0c82a49c7658699a9f879db290407a5032450025df72dfd1', '::1', '2025-05-13 21:58:03', '1747195778', 1),
(2, 1, 'b3f811b719ab22d8846c500a5a70ebba0cb78256112c18ae4452d093fed157f46109f4d57e811200', '::1', '2025-05-24 11:18:57', '1748110248', 1),
(3, 1, '14678ef0199586265bb23ad310157ad1830294226db660f5150677dcc3e1130ab53d95675b0aa320', '::1', '2025-06-17 05:15:13', '1750158925', 1),
(4, 1, 'db8808f4a036b25fe3477bee9a6144c8e13adf671c32bff778ae298c1819f111775a9642b6ad4413', '::1', '2025-06-17 20:19:51', '1750213192', 1),
(5, 1, '51bfc82fb3bfbd00da8f010678be41e1eb8dfd3335dc88ff5d83c54fd7bee13c9c4e0bb4154fb6d6', '::1', '2025-06-18 18:52:15', '1750302317', 1),
(6, 1, 'ed0803fb2763f56853191c22be10f1a90e5ebf84324d2b8034c42290f2b32480b24ae4520ad5991d', '::1', '2025-06-20 20:22:42', '1750477691', 1),
(7, 1, '5541f2dd311ae5be7666aaca83de8ba7815d2b3dd1f017ef3abea328b84a7e6a495e040d0fdec53a', '::1', '2025-06-21 12:25:46', '1750530656', 0),
(8, 1, 'a822efbd5dc7e0c1f9d62352f473a0698bcd84597f8f44ad956f3307483554ec3dcd5963ad4b43b7', '::1', '2025-06-21 13:34:48', '1750534649', 1),
(9, 1, 'df419044afb41444f004063dbad13a32c35582b86c6d11b291283965a1f5dfd4775633a86de4c5b3', '::1', '2025-06-21 18:32:18', '1750552695', 0),
(10, 1, 'ed771772db0baa6957001d75e985f9458ebe731a41f296824a78aeff043ec98df89d2e8e69928719', '::1', '2025-06-21 18:40:34', '1750555549', 1),
(11, 1, '0f2a25f0cd857f550469e1175da4cd4dac09e6eeef4c797e6be84e3612587f51e9486120fcd0dc36', '::1', '2025-06-21 23:09:44', '1750569329', 1),
(12, 1, '68b8ad34837f81844dad4b1626ba079caccb0e32e34eec3710b66a277038702713ed541d49699b3e', '::1', '2025-06-22 09:20:35', '1750605639', 0),
(13, 1, 'dc5efae594f7dc8f7f741b695f48e221a11c37064d849fa3efdd7440f242f68e86fef3273e91f47c', '::1', '2025-06-22 10:28:20', '1750609702', 1),
(14, 1, 'e6d0c93cda305259c84385b95d50d0374bd60d0f5a239c15df28ca0b44bb5d2dbb35a44d1b09dba3', '::1', '2025-06-22 19:37:53', '1750645834', 1),
(15, 1, 'f5e94d076be6cf372c60d94a03a21afa9c339401819eb895f99a5da3981d6d685fb4d431aa0d693d', '::1', '2025-06-24 21:33:54', '1750823656', 0),
(16, 1, 'fd2f04ba85eafd13621fae1a2fa6d6da314fc79de0c6f310fc64ca7563b5f15843ec4e4d5dc79dc7', '::1', '2025-06-24 23:20:57', '1750834560', 1),
(17, 1, '9e7d0f6930262316f4615c83be653bfaa42979c5cf830fe51e4c32f45b01f5b885b60463a611c484', '::1', '2025-06-25 13:10:34', '1750891222', 1),
(18, 1, 'c08ba35f5663b1d0405850c533fce3495e1e5ac2e282576115c887cc3aba5475cffd964266e27e02', '::1', '2025-06-25 20:13:29', '1750904015', 1),
(19, 1, 'aa8a9d3781115b3a19bffed2429f4314c5e4d79bce36adc42fa1fa358a97f9e5ec06d37901aabb7a', '::1', '2025-06-27 18:25:21', '1751071983', 0),
(20, 1, 'c94e304d5ce095cec7757ef056319d92704ec615d92d88778fe2a57b806350d6e5e9483fc3015415', '::1', '2025-06-27 22:30:42', '1751087344', 1),
(21, 1, '1e11df35e97dd5b8edd355f4e948453a3a37c8218a83e2e07142b97bdccdb4080ed879492cd7abdc', '::1', '2025-06-28 15:37:37', '1751156606', 0),
(22, 1, 'd555e35709e12fea3980d70d846a3ec5b6f84939418a1fcdf49c32aec96fe273e774297339ea0974', '::1', '2025-06-29 01:17:21', '1751183105', 0),
(23, 1, '7acb4fc9c76e9896a6543d271ed356666c0194b7b8f489b45b80d8dabd692da6fff6b5611d29447c', '::1', '2025-07-01 20:27:29', '1751424126', 0),
(24, 1, '4f2e51be125e79ea547c13fc7304335c74113522c292733f99f2b791031a1aafada6741783df9224', '::1', '2025-07-01 22:03:19', '1751435702', 1),
(25, 1, '14c2fa2116de690693094f945695cc9727b72a8777c9f9764801e449d16ce33c11e008a1588f03df', '::1', '2025-07-03 19:22:07', '1751599290', 0),
(26, 1, 'd7fb2ebf725f96999aeeb25ba408963fc1abeb05948965ae850166f02ef43eb297a6fe69a0f13d61', '::1', '2025-07-03 22:59:45', '1751611642', 1),
(27, 1, 'db96c43fa043d3ecfbe2c2eb9b0042235d665243b214c3f651637a7055506935fbade1a2ee85ad88', '::1', '2025-07-05 11:23:25', '1751743346', 1),
(28, 1, '8b5e8939d7d9cde9ad353f50eddac1b847c3c63fba283b40c7d8b482fdbbe348c30781980ca22ace', '::1', '2025-07-06 19:12:21', '1751851584', 0),
(29, 1, '9a113ed4345576fc91f366989ec6dd143c6a7c004a32552944f6db3b1f23610db30b4eeb0ab8a466', '::1', '2025-07-06 22:53:10', '1751875860', 1),
(30, 1, '16fc9ad46683736bc346978d98458d1a986bf9a7b123472de0fcd75e5da155bf30feaab22d65102f', '::1', '2025-07-07 09:23:56', '1751902169', 0),
(31, 1, '4d15613074790c1492cf7457642eca77cc7e651b5e2e7de78e0ce757772da180ac9ca52af99d0488', '::1', '2025-07-07 09:29:33', '1751902243', 0),
(32, 1, 'a0eb123a4f0c844692e676913f8e1f402ad735af40b7bcf9cb131faa01f12c4e8d46a4b4d53a883c', '::1', '2025-07-07 11:04:15', '1751944384', 0),
(33, 1, 'c242b3de1426bfcab74e3e9d80c61ed4d28410012ec557b5d660fb967d955e8c2ec1b08a1bbc8f45', '::1', '2025-07-07 22:20:55', '1751953378', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_submenus`
--

CREATE TABLE `sis_submenus` (
  `idsubmenu` int NOT NULL,
  `idmenu` int NOT NULL,
  `sub_nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_externo` tinyint(1) NOT NULL DEFAULT '0',
  `sub_controlador` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_metodo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'index',
  `sub_icono` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_orden` int NOT NULL DEFAULT '1',
  `sub_visible` tinyint(1) NOT NULL DEFAULT '1',
  `sub_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_submenus`
--

INSERT INTO `sis_submenus` (`idsubmenu`, `idmenu`, `sub_nombre`, `sub_url`, `sub_externo`, `sub_controlador`, `sub_metodo`, `sub_icono`, `sub_orden`, `sub_visible`, `sub_fecha`) VALUES
(1, 1, 'Menús', '/admin/menus', 0, 'MenusController', 'index', 'bx-menu', 1, 1, '2023-03-06 12:41:05'),
(2, 1, 'Submenús', '/admin/submenus', 0, 'SubMenusController', 'index', 'bx-menu-alt-right', 2, 1, '2023-03-06 12:41:44'),
(3, 1, 'Permisos', '/admin/permisos', 0, 'PermisosController', 'index', 'bx-key', 4, 1, '2023-03-06 12:42:10'),
(6, 1, 'P. Extras', '/admin/permisos-especiales', 0, 'PermisosEspecialesController', 'index', 'bx bx-key', 5, 1, '2025-02-17 11:52:57'),
(9, 6, 'Crear', '/admin/usuarios', 0, 'UsuariosController', 'index', 'bx bx-plus-medical text-success', 1, 1, '2025-02-18 18:02:34'),
(11, 6, 'Registrar Personas', '/admin/personas', 0, 'PersonasController', 'index', 'bxs-user-plus text-info', 2, 1, '2025-02-19 14:20:04'),
(12, 6, 'Roles', '/admin/roles', 0, 'RolesController', 'index', 'bx bx-plus-circle text-danger', 3, 1, '2025-02-19 14:22:27'),
(18, 9, 'Pacientes', '/admin/pacientes', 0, 'PacientesController', 'index', 'bx-circle', 1, 1, '2025-06-18 18:54:07'),
(19, 10, 'Nuevo', '/admin/cuestionarios/nuevo', 0, 'CuestionariosController', 'index', 'bx-circle', 1, 1, '2025-06-18 19:52:47'),
(20, 10, 'Lista', '/admin/cuestionarios', 0, 'CuestionariosController', 'index', 'bx-circle', 2, 1, '2025-06-18 21:02:55'),
(21, 10, 'Entrenar modelo', '/admin/entrenamiento', 0, 'EntrenarController', 'index', 'bx-circle', 3, 1, '2025-06-27 18:25:51'),
(22, 10, 'Prediccion', '/admin/predecir', 0, 'PredecirController', 'index', 'bx-circle', 4, 1, '2025-07-07 15:21:47'),
(23, 11, 'Mapa', '/admin/mapa', 0, 'MapaController', 'index', 'bx-circle', 1, 1, '2025-07-07 19:50:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sis_usuarios`
--

CREATE TABLE `sis_usuarios` (
  `idusuario` int NOT NULL,
  `idrol` int NOT NULL,
  `idpersona` int NOT NULL,
  `usu_usuario` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usu_pass` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usu_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usu_activo` tinyint(1) NOT NULL,
  `usu_estado` tinyint(1) NOT NULL,
  `usu_primera` tinyint(1) NOT NULL,
  `usu_twoauth` tinyint(1) NOT NULL,
  `usu_code_twoauth` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `usu_fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ultima_actualizacion` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sis_usuarios`
--

INSERT INTO `sis_usuarios` (`idusuario`, `idrol`, `idpersona`, `usu_usuario`, `usu_pass`, `usu_token`, `usu_activo`, `usu_estado`, `usu_primera`, `usu_twoauth`, `usu_code_twoauth`, `usu_fecha`, `ultima_actualizacion`) VALUES
(1, 1, 1, 'developer', '$2y$10$Fit/2psoTtAP.pctt2qiluYnf4vYcKqbGvFbZa.8/ngskf1HlwZvW', NULL, 1, 1, 0, 0, '', '2022-07-22 01:10:31', NULL),
(2, 4, 2, 'leenhcraft', '$2y$10$iTsh3NcBhufyfCBNG15NyuSsdAgfCsy.V1GMWa2wAeB1DaeVmqKIC', NULL, 1, 1, 1, 0, '', '2025-03-10 18:12:53', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_casos_distrito_mensual`
--

CREATE TABLE `vih_casos_distrito_mensual` (
  `id_casos_distrito` int NOT NULL,
  `id_distrito` int NOT NULL,
  `anio` int NOT NULL,
  `mes` int NOT NULL,
  `casos_nuevos_vih` int NOT NULL,
  `casos_confirmados` int NOT NULL,
  `casos_sospechosos` int NOT NULL,
  `total_cuestionarios_aplicados` int NOT NULL,
  `casos_riesgo_alto` int NOT NULL,
  `casos_riesgo_medio` int NOT NULL,
  `casos_riesgo_bajo` int NOT NULL,
  `tasa_incidencia_100k` double NOT NULL,
  `tasa_positividad` double NOT NULL,
  `fecha_calculo` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_configuracion`
--

CREATE TABLE `vih_configuracion` (
  `idconfig` int NOT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `vih_configuracion`
--

INSERT INTO `vih_configuracion` (`idconfig`, `nombre`, `valor`, `date`) VALUES
(1, 'rutas', '{\"nombre_dataset\":\"..\\/app\\/XGBoost\\/Datasets\\/demo_dataset_vih.csv\",\"ruta_dataset\":\"..\\/app\\/XGBoost\\/Datasets\\/\",\"nombre_modelo\":\"modelo_entrenado_2025-07-07_18-32-02\",\"ruta_modelo\":\"..\\/app\\/XGBoost\\/Modelos\\/modelo_entrenado_2025-07-07_18-32-02\",\"nombre_pred\":\"pred.csv\",\"ruta_pred\":\"..\\/app\\/XGBoost\\/Predicciones\\/\",\"debug\":0}', '2025-07-05 12:14:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_cuestionario_vih`
--

CREATE TABLE `vih_cuestionario_vih` (
  `id_cuestionario` int NOT NULL,
  `id_paciente` int NOT NULL,
  `id_personal` int NOT NULL,
  `id_establecimiento` int NOT NULL,
  `fecha_aplicacion` datetime DEFAULT NULL,
  `num_cuestionario` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones_generales` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_datasets`
--

CREATE TABLE `vih_datasets` (
  `id_dataset` int NOT NULL,
  `nombre_dataset` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_generacion` datetime NOT NULL,
  `ruta_datasets` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dataset_activo` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_datos_sociodemograficos`
--

CREATE TABLE `vih_datos_sociodemograficos` (
  `id_sociodemografico` int NOT NULL,
  `id_cuestionario` int NOT NULL,
  `edad` int NOT NULL,
  `sexo` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_civil` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nivel_educativo` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ocupacion_actual` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `lugar_residencia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_demograficos_distrito`
--

CREATE TABLE `vih_demograficos_distrito` (
  `id_demografico_distrito` int NOT NULL,
  `id_distrito` int NOT NULL,
  `anio` int NOT NULL,
  `mes` int NOT NULL,
  `poblacion_15_29_m` int NOT NULL,
  `poblacion_15_29_f` int NOT NULL,
  `poblacion_30_39_m` int NOT NULL,
  `poblacion_30_39_f` int NOT NULL,
  `poblacion_40_59_m` int NOT NULL,
  `poblacion_40_59_f` int NOT NULL,
  `tasa_alfabetizacion` double NOT NULL,
  `centros_salud_activos` int NOT NULL,
  `fecha_actualizacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_distrito`
--

CREATE TABLE `vih_distrito` (
  `id_distrito` int NOT NULL,
  `nombre_distrito` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `distrito_codigo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `poblacion_total` int NOT NULL,
  `area_km2` double NOT NULL,
  `capital_distrito` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `vih_distrito`
--

INSERT INTO `vih_distrito` (`id_distrito`, `nombre_distrito`, `distrito_codigo`, `poblacion_total`, `area_km2`, `capital_distrito`, `activo`) VALUES
(1, 'Moyobamba', 'Moyobamba', 62000, 365.42, 'Moyobamba', 1),
(2, 'Calzada', 'Calzada', 8500, 234.15, 'Calzada', 1),
(3, 'Habana', 'Habana', 4200, 178.9, 'Habana', 1),
(4, 'Jepelacio', 'Jepelacio', 12800, 409.33, 'Jepelacio', 1),
(5, 'Soritor', 'Soritor', 18500, 665.48, 'Soritor', 1),
(6, 'Yantaló', 'Yantalo', 3100, 112.67, 'Yantaló', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_establecimiento_salud`
--

CREATE TABLE `vih_establecimiento_salud` (
  `id_establecimiento` int NOT NULL,
  `id_distrito` int NOT NULL,
  `nombre_establecimiento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_establecimiento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `zona` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `microred` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `vih_establecimiento_salud`
--

INSERT INTO `vih_establecimiento_salud` (`id_establecimiento`, `id_distrito`, `nombre_establecimiento`, `codigo_establecimiento`, `zona`, `microred`, `direccion`, `activo`) VALUES
(1, 1, 'Hospital II-1 Moyobamba', 'hospital_moyobamba', 'Urbana', 'Barrio Calvario', 'Barrio Calvario, Moyobamba', 1),
(2, 1, 'Puesto de Salud Tahuishco', 'ps_tahuishco', 'Rural', 'Lluyllucucha', 'Sector Tahuishco, Moyobamba', 1),
(3, 2, 'Puesto de Salud Calzada', 'ps_calzada', 'Urbana', 'Calzada', 'Plaza de Armas, Calzada', 1),
(4, 5, 'Puesto de Salud San Marcos', 'ps_san_marcos', 'Rural', 'Soritor', 'Caserío San Marcos, Soritor', 1),
(5, 3, 'Centro de Salud Habana', 'cs_habana', 'Rural', 'Habana', 'Plaza Principal, Habana', 1),
(6, 4, 'Centro de Salud Jepelacio', 'cs_jepelacio', 'Urbana', 'Jerillo', 'Jr. Principal, Jepelacio', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_factores_distrito`
--

CREATE TABLE `vih_factores_distrito` (
  `id_factor_distrito` int NOT NULL,
  `id_distrito` int NOT NULL,
  `anio` int NOT NULL,
  `mes` int NOT NULL,
  `indice_pobreza` double NOT NULL,
  `programas_prevencion_activos` int NOT NULL,
  `campanias_vih_mes` tinyint(1) NOT NULL,
  `cobertura_preservativos` double NOT NULL,
  `eventos_riesgos` int NOT NULL,
  `accesibilidad_servicios` double NOT NULL,
  `observaciones` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_registro` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_factores_riesgo`
--

CREATE TABLE `vih_factores_riesgo` (
  `id_factores_riesgo` int NOT NULL,
  `id_cuestionario` int NOT NULL,
  `uso_preservativos_pre_diagnostico` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `relaciones_sin_proteccion_post_diagnostico` tinyint(1) NOT NULL,
  `numero_parejas_ultimo_anio` int NOT NULL,
  `relaciones_mismo_sexo` tinyint(1) NOT NULL,
  `uso_drogas_inyectables` tinyint(1) NOT NULL,
  `transfusiones_ultimos_5_anios` tinyint(1) NOT NULL,
  `antecedentes_its` tinyint(1) NOT NULL,
  `detalle_its_previas` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `relaciones_ocasionales_post_diagnostico` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_informacion_clinica`
--

CREATE TABLE `vih_informacion_clinica` (
  `id_clinica` int NOT NULL,
  `id_cuestionario` int NOT NULL,
  `fecha_diagnostico_vih` date DEFAULT NULL,
  `tipo_prueba_diagnostico` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `otro_tipo_prueba` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `recibe_tar` tinyint(1) NOT NULL,
  `fecha_inicio_tar` date DEFAULT NULL,
  `ultimo_cd4` int NOT NULL,
  `unidad_cd4` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ultima_carga_viral` int NOT NULL,
  `unidad_carga_viral` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `presenta_its_actual` int NOT NULL,
  `conoce_its_actual` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_modelo_prediccion_distrito`
--

CREATE TABLE `vih_modelo_prediccion_distrito` (
  `id_modelo` int NOT NULL,
  `id_dataset` int NOT NULL,
  `nombre_modelo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `version_modelo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `algoritmo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `parametros_xgboost` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `accuracy` double DEFAULT NULL,
  `mae_casos` double NOT NULL,
  `rmse_casos` double NOT NULL,
  `mape_porcentual` double NOT NULL,
  `fecha_entrenamiento` datetime DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `modelo_activo` tinyint(1) NOT NULL DEFAULT '0',
  `horizonte_prediccion_meses` int NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_paciente`
--

CREATE TABLE `vih_paciente` (
  `id_paciente` int NOT NULL,
  `nombre_completo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_documento` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_documento` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_personal_medico`
--

CREATE TABLE `vih_personal_medico` (
  `id_personal` int NOT NULL,
  `nombre_completo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `especialidad` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `cargo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_establecimiento` int NOT NULL,
  `activo` tinyint(1) NOT NULL,
  `fecha_registro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `vih_personal_medico`
--

INSERT INTO `vih_personal_medico` (`id_personal`, `nombre_completo`, `especialidad`, `cargo`, `id_establecimiento`, `activo`, `fecha_registro`) VALUES
(1, 'Carlos Alberto Pérez Ramírez', 'Medicina Interna', 'Médico Asistente', 1, 1, '2025-06-25 00:29:33'),
(2, 'María Elena García Vásquez', 'Infectología', 'Médico Especialista', 1, 1, '2025-06-25 00:29:33'),
(3, 'José Luis Mendoza Torres', 'Medicina General', 'Médico General', 1, 1, '2025-06-25 00:29:33'),
(4, 'Ana Patricia Silva Rojas', 'Enfermería', 'Enfermera Jefe', 1, 1, '2025-06-25 00:29:33'),
(5, 'Roberto Carlos Chávez Luna', 'Medicina General', 'Médico General', 2, 1, '2025-06-25 00:29:33'),
(6, 'Lucía Mercedes Fernández Díaz', 'Enfermería', 'Enfermera', 2, 1, '2025-06-25 00:29:33'),
(7, 'Patricia Rocío Vargas Pinedo', 'Medicina General', 'Médico General', 3, 1, '2025-06-25 00:29:33'),
(8, 'Carmen Rosa Paredes Hidalgo', 'Enfermería', 'Enfermera', 3, 1, '2025-06-25 00:29:33'),
(9, 'Fernando José Ríos Campos', 'Medicina General', 'Médico General', 4, 1, '2025-06-25 00:29:33'),
(10, 'Gladys Maribel Torres Vela', 'Enfermería', 'Enfermera', 4, 1, '2025-06-25 00:29:33'),
(11, 'Daniel Augusto Morales Cruz', 'Medicina Familiar', 'Médico Jefe', 5, 1, '2025-06-25 00:29:33'),
(12, 'Rosa María Delgado Ruiz', 'Enfermería', 'Enfermera', 5, 1, '2025-06-25 00:29:33'),
(13, 'Víctor Manuel Aquino Sandoval', 'Medicina General', 'Médico General', 6, 1, '2025-06-25 00:29:33'),
(14, 'Nelly Esperanza Cárdenas Flores', 'Enfermería', 'Enfermera', 6, 1, '2025-06-25 00:29:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_predicciones`
--

CREATE TABLE `vih_predicciones` (
  `id_prediccion_modelo` int NOT NULL,
  `id_modelo` int NOT NULL,
  `codigo_prediccion` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_prediccion` datetime NOT NULL,
  `casos_predichos` int NOT NULL,
  `horizonte_prediccion_meses` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_prediccion_casos_distrito`
--

CREATE TABLE `vih_prediccion_casos_distrito` (
  `id_prediccion` int NOT NULL,
  `id_prediccion_modelo` int NOT NULL,
  `id_distrito` int NOT NULL,
  `anio_prediccion` int NOT NULL,
  `mes_prediccion` int NOT NULL,
  `casos_predichos` int NOT NULL,
  `casos_minimos_ic95` int NOT NULL,
  `casos_maximos_ic95` int NOT NULL,
  `probabilidad_incremento` double NOT NULL,
  `tendencia_esperada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nivel_alerta` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_prediccion` datetime NOT NULL,
  `factores_influyentes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_reentrenaminto_modelo`
--

CREATE TABLE `vih_reentrenaminto_modelo` (
  `id_reentrenamiento` int NOT NULL,
  `id_modelo` int NOT NULL,
  `fecha_reentrenamiento` datetime NOT NULL,
  `motivo_reentrenamiento` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `registros_entrenamiento` int NOT NULL,
  `meses_datos_utilizados` int NOT NULL,
  `mejora_accuracy` double NOT NULL,
  `cambios_hiperparametros` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reentrenamiento_exitoso` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_riesgo_transmision`
--

CREATE TABLE `vih_riesgo_transmision` (
  `id_riesgo` int NOT NULL,
  `id_cuestionario` int NOT NULL,
  `tiene_pareja_activa` tinyint(1) NOT NULL,
  `informa_estado_vih` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `uso_preservativo_actual` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pareja_prueba_vih` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `sis_acciones`
--
ALTER TABLE `sis_acciones`
  ADD PRIMARY KEY (`idaccion`);

--
-- Indices de la tabla `sis_centinela`
--
ALTER TABLE `sis_centinela`
  ADD PRIMARY KEY (`idcentinela`);

--
-- Indices de la tabla `sis_menus`
--
ALTER TABLE `sis_menus`
  ADD PRIMARY KEY (`idmenu`);

--
-- Indices de la tabla `sis_permisos`
--
ALTER TABLE `sis_permisos`
  ADD PRIMARY KEY (`idpermisos`);

--
-- Indices de la tabla `sis_permisos_extras`
--
ALTER TABLE `sis_permisos_extras`
  ADD PRIMARY KEY (`idpermiso`);

--
-- Indices de la tabla `sis_personal`
--
ALTER TABLE `sis_personal`
  ADD PRIMARY KEY (`idpersona`);

--
-- Indices de la tabla `sis_recursos`
--
ALTER TABLE `sis_recursos`
  ADD PRIMARY KEY (`idrecurso`);

--
-- Indices de la tabla `sis_rol`
--
ALTER TABLE `sis_rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `sis_server_email`
--
ALTER TABLE `sis_server_email`
  ADD PRIMARY KEY (`idserveremail`);

--
-- Indices de la tabla `sis_sesiones`
--
ALTER TABLE `sis_sesiones`
  ADD PRIMARY KEY (`idsesion`);

--
-- Indices de la tabla `sis_submenus`
--
ALTER TABLE `sis_submenus`
  ADD PRIMARY KEY (`idsubmenu`);

--
-- Indices de la tabla `sis_usuarios`
--
ALTER TABLE `sis_usuarios`
  ADD PRIMARY KEY (`idusuario`);

--
-- Indices de la tabla `vih_casos_distrito_mensual`
--
ALTER TABLE `vih_casos_distrito_mensual`
  ADD PRIMARY KEY (`id_casos_distrito`);

--
-- Indices de la tabla `vih_configuracion`
--
ALTER TABLE `vih_configuracion`
  ADD PRIMARY KEY (`idconfig`);

--
-- Indices de la tabla `vih_cuestionario_vih`
--
ALTER TABLE `vih_cuestionario_vih`
  ADD PRIMARY KEY (`id_cuestionario`);

--
-- Indices de la tabla `vih_datasets`
--
ALTER TABLE `vih_datasets`
  ADD PRIMARY KEY (`id_dataset`);

--
-- Indices de la tabla `vih_datos_sociodemograficos`
--
ALTER TABLE `vih_datos_sociodemograficos`
  ADD PRIMARY KEY (`id_sociodemografico`);

--
-- Indices de la tabla `vih_demograficos_distrito`
--
ALTER TABLE `vih_demograficos_distrito`
  ADD PRIMARY KEY (`id_demografico_distrito`);

--
-- Indices de la tabla `vih_distrito`
--
ALTER TABLE `vih_distrito`
  ADD PRIMARY KEY (`id_distrito`);

--
-- Indices de la tabla `vih_establecimiento_salud`
--
ALTER TABLE `vih_establecimiento_salud`
  ADD PRIMARY KEY (`id_establecimiento`);

--
-- Indices de la tabla `vih_factores_distrito`
--
ALTER TABLE `vih_factores_distrito`
  ADD PRIMARY KEY (`id_factor_distrito`);

--
-- Indices de la tabla `vih_factores_riesgo`
--
ALTER TABLE `vih_factores_riesgo`
  ADD PRIMARY KEY (`id_factores_riesgo`);

--
-- Indices de la tabla `vih_informacion_clinica`
--
ALTER TABLE `vih_informacion_clinica`
  ADD PRIMARY KEY (`id_clinica`);

--
-- Indices de la tabla `vih_modelo_prediccion_distrito`
--
ALTER TABLE `vih_modelo_prediccion_distrito`
  ADD PRIMARY KEY (`id_modelo`);

--
-- Indices de la tabla `vih_paciente`
--
ALTER TABLE `vih_paciente`
  ADD PRIMARY KEY (`id_paciente`);

--
-- Indices de la tabla `vih_personal_medico`
--
ALTER TABLE `vih_personal_medico`
  ADD PRIMARY KEY (`id_personal`);

--
-- Indices de la tabla `vih_predicciones`
--
ALTER TABLE `vih_predicciones`
  ADD PRIMARY KEY (`id_prediccion_modelo`);

--
-- Indices de la tabla `vih_prediccion_casos_distrito`
--
ALTER TABLE `vih_prediccion_casos_distrito`
  ADD PRIMARY KEY (`id_prediccion`);

--
-- Indices de la tabla `vih_reentrenaminto_modelo`
--
ALTER TABLE `vih_reentrenaminto_modelo`
  ADD PRIMARY KEY (`id_reentrenamiento`);

--
-- Indices de la tabla `vih_riesgo_transmision`
--
ALTER TABLE `vih_riesgo_transmision`
  ADD PRIMARY KEY (`id_riesgo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `sis_acciones`
--
ALTER TABLE `sis_acciones`
  MODIFY `idaccion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `sis_centinela`
--
ALTER TABLE `sis_centinela`
  MODIFY `idcentinela` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3197;

--
-- AUTO_INCREMENT de la tabla `sis_menus`
--
ALTER TABLE `sis_menus`
  MODIFY `idmenu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `sis_permisos`
--
ALTER TABLE `sis_permisos`
  MODIFY `idpermisos` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de la tabla `sis_permisos_extras`
--
ALTER TABLE `sis_permisos_extras`
  MODIFY `idpermiso` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `sis_personal`
--
ALTER TABLE `sis_personal`
  MODIFY `idpersona` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sis_recursos`
--
ALTER TABLE `sis_recursos`
  MODIFY `idrecurso` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `sis_rol`
--
ALTER TABLE `sis_rol`
  MODIFY `idrol` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `sis_server_email`
--
ALTER TABLE `sis_server_email`
  MODIFY `idserveremail` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sis_sesiones`
--
ALTER TABLE `sis_sesiones`
  MODIFY `idsesion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `sis_submenus`
--
ALTER TABLE `sis_submenus`
  MODIFY `idsubmenu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `sis_usuarios`
--
ALTER TABLE `sis_usuarios`
  MODIFY `idusuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `vih_casos_distrito_mensual`
--
ALTER TABLE `vih_casos_distrito_mensual`
  MODIFY `id_casos_distrito` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_configuracion`
--
ALTER TABLE `vih_configuracion`
  MODIFY `idconfig` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `vih_cuestionario_vih`
--
ALTER TABLE `vih_cuestionario_vih`
  MODIFY `id_cuestionario` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_datasets`
--
ALTER TABLE `vih_datasets`
  MODIFY `id_dataset` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_datos_sociodemograficos`
--
ALTER TABLE `vih_datos_sociodemograficos`
  MODIFY `id_sociodemografico` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_demograficos_distrito`
--
ALTER TABLE `vih_demograficos_distrito`
  MODIFY `id_demografico_distrito` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_distrito`
--
ALTER TABLE `vih_distrito`
  MODIFY `id_distrito` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `vih_establecimiento_salud`
--
ALTER TABLE `vih_establecimiento_salud`
  MODIFY `id_establecimiento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `vih_factores_distrito`
--
ALTER TABLE `vih_factores_distrito`
  MODIFY `id_factor_distrito` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_factores_riesgo`
--
ALTER TABLE `vih_factores_riesgo`
  MODIFY `id_factores_riesgo` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_informacion_clinica`
--
ALTER TABLE `vih_informacion_clinica`
  MODIFY `id_clinica` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_modelo_prediccion_distrito`
--
ALTER TABLE `vih_modelo_prediccion_distrito`
  MODIFY `id_modelo` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_paciente`
--
ALTER TABLE `vih_paciente`
  MODIFY `id_paciente` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_personal_medico`
--
ALTER TABLE `vih_personal_medico`
  MODIFY `id_personal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `vih_predicciones`
--
ALTER TABLE `vih_predicciones`
  MODIFY `id_prediccion_modelo` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_prediccion_casos_distrito`
--
ALTER TABLE `vih_prediccion_casos_distrito`
  MODIFY `id_prediccion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_reentrenaminto_modelo`
--
ALTER TABLE `vih_reentrenaminto_modelo`
  MODIFY `id_reentrenamiento` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vih_riesgo_transmision`
--
ALTER TABLE `vih_riesgo_transmision`
  MODIFY `id_riesgo` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
