-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 02-07-2025 a las 03:14:57
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
(9, 'Modulo Paciente', '#', NULL, 'bx bx-plus-medical', 0, 2, 1, '2025-06-18 18:53:44'),
(10, 'Modulo Predicción', '#', NULL, 'bx bx-circle', 0, 1, 1, '2025-06-18 19:52:07');

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
(24, 1, 21, 1, 0, 0, 0);

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
(5, 1, 2, 4, 1, '2025-06-18 18:55:24');

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
(2, 'Pacientes', NULL, 'ruta', 'pacientes', 1, '2025-06-18 18:55:02');

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
(24, 1, '4f2e51be125e79ea547c13fc7304335c74113522c292733f99f2b791031a1aafada6741783df9224', '::1', '2025-07-01 22:03:19', '1751429675', 1);

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
(21, 10, 'Entrenar modelo', '/admin/entrenamiento', 0, 'EntrenarController', 'index', 'bx-circle', 3, 1, '2025-06-27 18:25:51');

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

--
-- Volcado de datos para la tabla `vih_cuestionario_vih`
--

INSERT INTO `vih_cuestionario_vih` (`id_cuestionario`, `id_paciente`, `id_personal`, `id_establecimiento`, `fecha_aplicacion`, `num_cuestionario`, `estado`, `observaciones_generales`) VALUES
(1, 1, 1, 1, '2025-07-01 20:34:38', 'CVIH20250701203438665', 'Completo', ''),
(2, 2, 1, 1, '2025-07-01 20:34:38', 'CVIH20250701203438411', 'Completo', ''),
(3, 3, 1, 3, '2025-07-01 20:34:38', 'CVIH20250701203438921', 'Completo', ''),
(4, 4, 1, 2, '2025-07-01 20:34:38', 'CVIH20250701203438192', 'Completo', ''),
(5, 5, 1, 6, '2025-07-01 20:34:38', 'CVIH20250701203438488', 'Completo', ''),
(6, 6, 1, 3, '2025-07-01 20:34:38', 'CVIH20250701203438084', 'Completo', ''),
(7, 7, 1, 4, '2025-07-01 20:34:39', 'CVIH20250701203439624', 'Completo', ''),
(8, 8, 1, 6, '2025-07-01 20:34:39', 'CVIH20250701203439531', 'Completo', ''),
(9, 9, 1, 2, '2025-07-01 20:34:39', 'CVIH20250701203439531', 'Completo', ''),
(10, 10, 1, 5, '2025-07-01 20:34:39', 'CVIH20250701203439136', 'Completo', ''),
(11, 11, 1, 6, '2025-07-01 20:34:39', 'CVIH20250701203439096', 'Completo', ''),
(12, 12, 1, 1, '2025-07-01 20:34:39', 'CVIH20250701203439298', 'Completo', ''),
(13, 13, 1, 5, '2025-07-01 20:34:39', 'CVIH20250701203439240', 'Completo', ''),
(14, 14, 1, 3, '2025-07-01 20:34:39', 'CVIH20250701203439333', 'Completo', ''),
(15, 15, 1, 6, '2025-07-01 20:34:40', 'CVIH20250701203440064', 'Completo', ''),
(16, 16, 1, 3, '2025-07-01 20:34:40', 'CVIH20250701203440949', 'Completo', ''),
(17, 17, 1, 1, '2025-07-01 20:34:40', 'CVIH20250701203440848', 'Completo', ''),
(18, 18, 1, 4, '2025-07-01 20:34:40', 'CVIH20250701203440797', 'Completo', ''),
(19, 19, 1, 5, '2025-07-01 20:34:40', 'CVIH20250701203440004', 'Completo', ''),
(20, 20, 1, 6, '2025-07-01 20:34:40', 'CVIH20250701203440406', 'Completo', ''),
(21, 21, 1, 5, '2025-07-01 20:34:40', 'CVIH20250701203440361', 'Completo', ''),
(22, 22, 1, 4, '2025-07-01 20:34:40', 'CVIH20250701203440937', 'Completo', ''),
(23, 23, 1, 4, '2025-07-01 20:34:40', 'CVIH20250701203440927', 'Completo', ''),
(24, 24, 1, 5, '2025-07-01 20:34:40', 'CVIH20250701203440818', 'Completo', ''),
(25, 25, 1, 3, '2025-07-01 20:34:41', 'CVIH20250701203441315', 'Completo', ''),
(26, 26, 1, 3, '2025-07-01 20:34:41', 'CVIH20250701203441094', 'Completo', ''),
(27, 27, 1, 2, '2025-07-01 20:34:41', 'CVIH20250701203441693', 'Completo', ''),
(28, 28, 1, 1, '2025-07-01 20:34:41', 'CVIH20250701203441428', 'Completo', ''),
(29, 29, 1, 3, '2025-07-01 20:34:41', 'CVIH20250701203441352', 'Completo', ''),
(30, 30, 1, 1, '2025-07-01 20:34:41', 'CVIH20250701203441508', 'Completo', ''),
(31, 31, 1, 3, '2025-07-01 20:34:41', 'CVIH20250701203441830', 'Completo', ''),
(32, 32, 1, 1, '2025-07-01 20:34:41', 'CVIH20250701203441636', 'Completo', ''),
(33, 33, 1, 2, '2025-07-01 20:34:41', 'CVIH20250701203441374', 'Completo', ''),
(34, 34, 1, 4, '2025-07-01 20:34:42', 'CVIH20250701203442648', 'Completo', ''),
(35, 35, 1, 6, '2025-07-01 20:34:42', 'CVIH20250701203442802', 'Completo', ''),
(36, 36, 1, 5, '2025-07-01 20:34:42', 'CVIH20250701203442493', 'Completo', ''),
(37, 37, 1, 6, '2025-07-01 20:34:42', 'CVIH20250701203442739', 'Completo', ''),
(38, 38, 1, 6, '2025-07-01 20:34:42', 'CVIH20250701203442273', 'Completo', ''),
(39, 39, 1, 2, '2025-07-01 20:34:42', 'CVIH20250701203442411', 'Completo', ''),
(40, 40, 1, 2, '2025-07-01 20:34:42', 'CVIH20250701203442099', 'Completo', ''),
(41, 41, 1, 5, '2025-07-01 20:34:42', 'CVIH20250701203442365', 'Completo', ''),
(42, 42, 1, 6, '2025-07-01 20:34:42', 'CVIH20250701203442119', 'Completo', ''),
(43, 43, 1, 6, '2025-07-01 20:34:42', 'CVIH20250701203442471', 'Completo', ''),
(44, 44, 1, 2, '2025-07-01 20:34:42', 'CVIH20250701203442069', 'Completo', ''),
(45, 45, 1, 2, '2025-07-01 20:34:43', 'CVIH20250701203443588', 'Completo', ''),
(46, 46, 1, 2, '2025-07-01 20:34:43', 'CVIH20250701203443786', 'Completo', ''),
(47, 47, 1, 3, '2025-07-01 20:34:43', 'CVIH20250701203443255', 'Completo', ''),
(48, 48, 1, 4, '2025-07-01 20:34:43', 'CVIH20250701203443975', 'Completo', ''),
(49, 49, 1, 5, '2025-07-01 20:34:43', 'CVIH20250701203443492', 'Completo', ''),
(50, 50, 1, 6, '2025-07-01 20:34:43', 'CVIH20250701203443635', 'Completo', ''),
(51, 51, 1, 1, '2025-07-01 20:34:43', 'CVIH20250701203443405', 'Completo', ''),
(52, 52, 1, 1, '2025-07-01 20:34:43', 'CVIH20250701203443630', 'Completo', ''),
(53, 53, 1, 2, '2025-07-01 20:34:43', 'CVIH20250701203443867', 'Completo', ''),
(54, 54, 1, 1, '2025-07-01 20:34:44', 'CVIH20250701203444702', 'Completo', ''),
(55, 55, 1, 2, '2025-07-01 20:34:44', 'CVIH20250701203444554', 'Completo', ''),
(56, 56, 1, 2, '2025-07-01 20:34:44', 'CVIH20250701203444613', 'Completo', ''),
(57, 57, 1, 2, '2025-07-01 20:34:44', 'CVIH20250701203444752', 'Completo', ''),
(58, 58, 1, 2, '2025-07-01 20:34:44', 'CVIH20250701203444712', 'Completo', ''),
(59, 59, 1, 1, '2025-07-01 20:34:44', 'CVIH20250701203444249', 'Completo', ''),
(60, 60, 1, 2, '2025-07-01 20:34:44', 'CVIH20250701203444175', 'Completo', ''),
(61, 61, 1, 4, '2025-07-01 20:34:44', 'CVIH20250701203444649', 'Completo', ''),
(62, 62, 1, 6, '2025-07-01 20:34:44', 'CVIH20250701203444429', 'Completo', ''),
(63, 63, 1, 5, '2025-07-01 20:34:44', 'CVIH20250701203444053', 'Completo', ''),
(64, 64, 1, 1, '2025-07-01 20:34:45', 'CVIH20250701203445512', 'Completo', ''),
(65, 65, 1, 4, '2025-07-01 20:34:45', 'CVIH20250701203445637', 'Completo', ''),
(66, 66, 1, 3, '2025-07-01 20:34:45', 'CVIH20250701203445321', 'Completo', ''),
(67, 67, 1, 4, '2025-07-01 20:34:45', 'CVIH20250701203445589', 'Completo', ''),
(68, 68, 1, 1, '2025-07-01 20:34:45', 'CVIH20250701203445847', 'Completo', ''),
(69, 69, 1, 2, '2025-07-01 20:34:45', 'CVIH20250701203445450', 'Completo', ''),
(70, 70, 1, 4, '2025-07-01 20:34:45', 'CVIH20250701203445189', 'Completo', ''),
(71, 71, 1, 6, '2025-07-01 20:34:45', 'CVIH20250701203445374', 'Completo', ''),
(72, 72, 1, 4, '2025-07-01 20:34:45', 'CVIH20250701203445034', 'Completo', ''),
(73, 73, 1, 2, '2025-07-01 20:34:45', 'CVIH20250701203445814', 'Completo', ''),
(74, 74, 1, 3, '2025-07-01 20:34:46', 'CVIH20250701203446107', 'Completo', ''),
(75, 75, 1, 3, '2025-07-01 20:34:46', 'CVIH20250701203446810', 'Completo', ''),
(76, 76, 1, 1, '2025-07-01 20:34:46', 'CVIH20250701203446861', 'Completo', ''),
(77, 77, 1, 5, '2025-07-01 20:34:46', 'CVIH20250701203446742', 'Completo', ''),
(78, 78, 1, 6, '2025-07-01 20:34:46', 'CVIH20250701203446575', 'Completo', ''),
(79, 79, 1, 1, '2025-07-01 20:34:46', 'CVIH20250701203446102', 'Completo', ''),
(80, 80, 1, 6, '2025-07-01 20:34:46', 'CVIH20250701203446600', 'Completo', ''),
(81, 81, 1, 2, '2025-07-01 20:34:46', 'CVIH20250701203446387', 'Completo', ''),
(82, 82, 1, 2, '2025-07-01 20:34:46', 'CVIH20250701203446463', 'Completo', ''),
(83, 83, 1, 6, '2025-07-01 20:34:46', 'CVIH20250701203446113', 'Completo', ''),
(84, 84, 1, 4, '2025-07-01 20:34:46', 'CVIH20250701203446794', 'Completo', ''),
(85, 85, 1, 6, '2025-07-01 20:34:46', 'CVIH20250701203446871', 'Completo', ''),
(86, 86, 1, 1, '2025-07-01 20:34:46', 'CVIH20250701203446098', 'Completo', ''),
(87, 87, 1, 3, '2025-07-01 20:34:46', 'CVIH20250701203446812', 'Completo', ''),
(88, 88, 1, 4, '2025-07-01 20:34:46', 'CVIH20250701203446026', 'Completo', ''),
(89, 89, 1, 4, '2025-07-01 20:34:46', 'CVIH20250701203446992', 'Completo', ''),
(90, 90, 1, 5, '2025-07-01 20:34:46', 'CVIH20250701203446796', 'Completo', ''),
(91, 91, 1, 1, '2025-07-01 20:34:46', 'CVIH20250701203446483', 'Completo', ''),
(92, 92, 1, 2, '2025-07-01 20:34:46', 'CVIH20250701203446060', 'Completo', ''),
(93, 93, 1, 3, '2025-07-01 20:34:47', 'CVIH20250701203447988', 'Completo', ''),
(94, 94, 1, 2, '2025-07-01 20:34:47', 'CVIH20250701203447825', 'Completo', ''),
(95, 95, 1, 1, '2025-07-01 20:34:47', 'CVIH20250701203447176', 'Completo', ''),
(96, 96, 1, 3, '2025-07-01 20:34:47', 'CVIH20250701203447905', 'Completo', ''),
(97, 97, 1, 4, '2025-07-01 20:34:47', 'CVIH20250701203447902', 'Completo', ''),
(98, 98, 1, 4, '2025-07-01 20:34:47', 'CVIH20250701203447013', 'Completo', ''),
(99, 99, 1, 6, '2025-07-01 20:34:47', 'CVIH20250701203447495', 'Completo', ''),
(100, 100, 1, 5, '2025-07-01 20:34:47', 'CVIH20250701203447186', 'Completo', ''),
(101, 101, 1, 2, '2025-07-01 20:34:47', 'CVIH20250701203447808', 'Completo', ''),
(102, 102, 1, 2, '2025-07-01 20:34:47', 'CVIH20250701203447722', 'Completo', ''),
(103, 103, 1, 5, '2025-07-01 20:34:48', 'CVIH20250701203448244', 'Completo', ''),
(104, 104, 1, 3, '2025-07-01 20:34:48', 'CVIH20250701203448883', 'Completo', ''),
(105, 105, 1, 5, '2025-07-01 20:34:48', 'CVIH20250701203448596', 'Completo', ''),
(106, 106, 1, 3, '2025-07-01 20:34:48', 'CVIH20250701203448192', 'Completo', ''),
(107, 107, 1, 3, '2025-07-01 20:34:48', 'CVIH20250701203448850', 'Completo', ''),
(108, 108, 1, 2, '2025-07-01 20:34:48', 'CVIH20250701203448622', 'Completo', ''),
(109, 109, 1, 3, '2025-07-01 20:34:48', 'CVIH20250701203448424', 'Completo', ''),
(110, 110, 1, 5, '2025-07-01 20:34:48', 'CVIH20250701203448879', 'Completo', ''),
(111, 111, 1, 3, '2025-07-01 20:34:48', 'CVIH20250701203448530', 'Completo', ''),
(112, 112, 1, 4, '2025-07-01 20:34:49', 'CVIH20250701203449389', 'Completo', ''),
(113, 113, 1, 5, '2025-07-01 20:34:49', 'CVIH20250701203449392', 'Completo', ''),
(114, 114, 1, 5, '2025-07-01 20:34:49', 'CVIH20250701203449356', 'Completo', ''),
(115, 115, 1, 3, '2025-07-01 20:34:49', 'CVIH20250701203449383', 'Completo', ''),
(116, 116, 1, 3, '2025-07-01 20:34:49', 'CVIH20250701203449768', 'Completo', ''),
(117, 117, 1, 3, '2025-07-01 20:34:49', 'CVIH20250701203449412', 'Completo', ''),
(118, 118, 1, 5, '2025-07-01 20:34:49', 'CVIH20250701203449886', 'Completo', ''),
(119, 119, 1, 5, '2025-07-01 20:34:49', 'CVIH20250701203449816', 'Completo', ''),
(120, 120, 1, 3, '2025-07-01 20:34:50', 'CVIH20250701203450608', 'Completo', ''),
(121, 121, 1, 5, '2025-07-01 20:34:50', 'CVIH20250701203450898', 'Completo', ''),
(122, 122, 1, 5, '2025-07-01 20:34:50', 'CVIH20250701203450588', 'Completo', ''),
(123, 123, 1, 1, '2025-07-01 20:34:50', 'CVIH20250701203450235', 'Completo', ''),
(124, 124, 1, 1, '2025-07-01 20:34:50', 'CVIH20250701203450052', 'Completo', ''),
(125, 125, 1, 5, '2025-07-01 20:34:50', 'CVIH20250701203450333', 'Completo', ''),
(126, 126, 1, 5, '2025-07-01 20:34:50', 'CVIH20250701203450618', 'Completo', ''),
(127, 127, 1, 6, '2025-07-01 20:34:50', 'CVIH20250701203450485', 'Completo', ''),
(128, 128, 1, 4, '2025-07-01 20:34:50', 'CVIH20250701203450848', 'Completo', ''),
(129, 129, 1, 6, '2025-07-01 20:34:50', 'CVIH20250701203450676', 'Completo', ''),
(130, 130, 1, 4, '2025-07-01 20:34:51', 'CVIH20250701203451172', 'Completo', ''),
(131, 131, 1, 6, '2025-07-01 20:34:51', 'CVIH20250701203451234', 'Completo', ''),
(132, 132, 1, 2, '2025-07-01 20:34:51', 'CVIH20250701203451323', 'Completo', ''),
(133, 133, 1, 6, '2025-07-01 20:34:51', 'CVIH20250701203451480', 'Completo', ''),
(134, 134, 1, 5, '2025-07-01 20:34:51', 'CVIH20250701203451023', 'Completo', ''),
(135, 135, 1, 5, '2025-07-01 20:34:51', 'CVIH20250701203451851', 'Completo', ''),
(136, 136, 1, 3, '2025-07-01 20:34:51', 'CVIH20250701203451144', 'Completo', ''),
(137, 137, 1, 2, '2025-07-01 20:34:51', 'CVIH20250701203451473', 'Completo', ''),
(138, 138, 1, 1, '2025-07-01 20:34:51', 'CVIH20250701203451477', 'Completo', ''),
(139, 139, 1, 5, '2025-07-01 20:34:52', 'CVIH20250701203452617', 'Completo', ''),
(140, 140, 1, 6, '2025-07-01 20:34:52', 'CVIH20250701203452206', 'Completo', ''),
(141, 141, 1, 2, '2025-07-01 20:34:52', 'CVIH20250701203452663', 'Completo', ''),
(142, 142, 1, 3, '2025-07-01 20:34:52', 'CVIH20250701203452695', 'Completo', ''),
(143, 143, 1, 6, '2025-07-01 20:34:52', 'CVIH20250701203452497', 'Completo', ''),
(144, 144, 1, 6, '2025-07-01 20:34:52', 'CVIH20250701203452751', 'Completo', ''),
(145, 145, 1, 6, '2025-07-01 20:34:52', 'CVIH20250701203452737', 'Completo', ''),
(146, 146, 1, 4, '2025-07-01 20:34:52', 'CVIH20250701203452669', 'Completo', ''),
(147, 147, 1, 5, '2025-07-01 20:34:52', 'CVIH20250701203452112', 'Completo', ''),
(148, 148, 1, 5, '2025-07-01 20:34:52', 'CVIH20250701203452923', 'Completo', ''),
(149, 149, 1, 5, '2025-07-01 20:34:53', 'CVIH20250701203453376', 'Completo', ''),
(150, 150, 1, 4, '2025-07-01 20:34:53', 'CVIH20250701203453129', 'Completo', ''),
(151, 151, 1, 5, '2025-07-01 20:34:53', 'CVIH20250701203453301', 'Completo', ''),
(152, 152, 1, 1, '2025-07-01 20:34:53', 'CVIH20250701203453593', 'Completo', ''),
(153, 153, 1, 5, '2025-07-01 20:34:53', 'CVIH20250701203453579', 'Completo', ''),
(154, 154, 1, 5, '2025-07-01 20:34:53', 'CVIH20250701203453180', 'Completo', ''),
(155, 155, 1, 6, '2025-07-01 20:34:53', 'CVIH20250701203453976', 'Completo', ''),
(156, 156, 1, 2, '2025-07-01 20:34:53', 'CVIH20250701203453079', 'Completo', ''),
(157, 157, 1, 6, '2025-07-01 20:34:53', 'CVIH20250701203453465', 'Completo', ''),
(158, 158, 1, 6, '2025-07-01 20:34:53', 'CVIH20250701203453103', 'Completo', ''),
(159, 159, 1, 5, '2025-07-01 20:34:54', 'CVIH20250701203454862', 'Completo', ''),
(160, 160, 1, 5, '2025-07-01 20:34:54', 'CVIH20250701203454756', 'Completo', ''),
(161, 161, 1, 1, '2025-07-01 20:34:54', 'CVIH20250701203454606', 'Completo', ''),
(162, 162, 1, 6, '2025-07-01 20:34:54', 'CVIH20250701203454300', 'Completo', ''),
(163, 163, 1, 6, '2025-07-01 20:34:54', 'CVIH20250701203454287', 'Completo', ''),
(164, 164, 1, 4, '2025-07-01 20:34:54', 'CVIH20250701203454144', 'Completo', ''),
(165, 165, 1, 2, '2025-07-01 20:34:54', 'CVIH20250701203454770', 'Completo', ''),
(166, 166, 1, 3, '2025-07-01 20:34:54', 'CVIH20250701203454295', 'Completo', ''),
(167, 167, 1, 3, '2025-07-01 20:34:54', 'CVIH20250701203454087', 'Completo', ''),
(168, 168, 1, 5, '2025-07-01 20:34:54', 'CVIH20250701203454308', 'Completo', ''),
(169, 169, 1, 6, '2025-07-01 20:34:55', 'CVIH20250701203455746', 'Completo', ''),
(170, 170, 1, 3, '2025-07-01 20:34:55', 'CVIH20250701203455670', 'Completo', ''),
(171, 171, 1, 6, '2025-07-01 20:34:55', 'CVIH20250701203455986', 'Completo', ''),
(172, 172, 1, 1, '2025-07-01 20:34:55', 'CVIH20250701203455225', 'Completo', ''),
(173, 173, 1, 6, '2025-07-01 20:34:55', 'CVIH20250701203455026', 'Completo', ''),
(174, 174, 1, 3, '2025-07-01 20:34:55', 'CVIH20250701203455899', 'Completo', ''),
(175, 175, 1, 6, '2025-07-01 20:34:55', 'CVIH20250701203455400', 'Completo', ''),
(176, 176, 1, 6, '2025-07-01 20:34:55', 'CVIH20250701203455022', 'Completo', ''),
(177, 177, 1, 1, '2025-07-01 20:34:55', 'CVIH20250701203455583', 'Completo', ''),
(178, 178, 1, 2, '2025-07-01 20:34:56', 'CVIH20250701203456155', 'Completo', ''),
(179, 179, 1, 4, '2025-07-01 20:34:56', 'CVIH20250701203456488', 'Completo', ''),
(180, 180, 1, 3, '2025-07-01 20:34:56', 'CVIH20250701203456119', 'Completo', ''),
(181, 181, 1, 4, '2025-07-01 20:34:56', 'CVIH20250701203456147', 'Completo', ''),
(182, 182, 1, 6, '2025-07-01 20:34:56', 'CVIH20250701203456490', 'Completo', ''),
(183, 183, 1, 1, '2025-07-01 20:34:56', 'CVIH20250701203456268', 'Completo', ''),
(184, 184, 1, 5, '2025-07-01 20:34:56', 'CVIH20250701203456298', 'Completo', ''),
(185, 185, 1, 1, '2025-07-01 20:34:56', 'CVIH20250701203456547', 'Completo', ''),
(186, 186, 1, 6, '2025-07-01 20:34:56', 'CVIH20250701203456118', 'Completo', ''),
(187, 187, 1, 4, '2025-07-01 20:34:56', 'CVIH20250701203456752', 'Completo', ''),
(188, 188, 1, 1, '2025-07-01 20:34:56', 'CVIH20250701203456613', 'Completo', ''),
(189, 189, 1, 4, '2025-07-01 20:34:56', 'CVIH20250701203456710', 'Completo', ''),
(190, 190, 1, 1, '2025-07-01 20:34:56', 'CVIH20250701203456757', 'Completo', ''),
(191, 191, 1, 1, '2025-07-01 20:34:57', 'CVIH20250701203457923', 'Completo', ''),
(192, 192, 1, 4, '2025-07-01 20:34:57', 'CVIH20250701203457222', 'Completo', ''),
(193, 193, 1, 1, '2025-07-01 20:34:57', 'CVIH20250701203457598', 'Completo', ''),
(194, 194, 1, 1, '2025-07-01 20:34:57', 'CVIH20250701203457008', 'Completo', ''),
(195, 195, 1, 6, '2025-07-01 20:34:57', 'CVIH20250701203457679', 'Completo', ''),
(196, 196, 1, 3, '2025-07-01 20:34:57', 'CVIH20250701203457507', 'Completo', ''),
(197, 197, 1, 5, '2025-07-01 20:34:57', 'CVIH20250701203457560', 'Completo', ''),
(198, 198, 1, 3, '2025-07-01 20:34:57', 'CVIH20250701203457447', 'Completo', ''),
(199, 199, 1, 6, '2025-07-01 20:34:57', 'CVIH20250701203457159', 'Completo', ''),
(200, 200, 1, 5, '2025-07-01 20:34:57', 'CVIH20250701203457375', 'Completo', '');

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

--
-- Volcado de datos para la tabla `vih_datos_sociodemograficos`
--

INSERT INTO `vih_datos_sociodemograficos` (`id_sociodemografico`, `id_cuestionario`, `edad`, `sexo`, `estado_civil`, `nivel_educativo`, `ocupacion_actual`, `lugar_residencia`) VALUES
(1, 1, 18, 'Femenino', 'Conviviente', 'Primaria', 'desempleado', 'Avenida 2 86'),
(2, 2, 47, 'Femenino', 'Divorciado', 'Secundaria', 'empleado', 'Avenida 5 18'),
(3, 3, 21, 'Masculino', 'Divorciado', 'Posgrado', 'estudiante', 'Avenida 2 27'),
(4, 4, 15, 'Masculino', 'Conviviente', 'Primaria', 'empleado', 'Avenida 2 33'),
(5, 5, 45, 'Masculino', 'Casado', 'Secundaria', 'desempleado', 'Calle 1 79'),
(6, 6, 50, 'Femenino', 'Casado', 'Superior', 'empleado', 'Callejón 4 79'),
(7, 7, 29, 'Femenino', 'Casado', 'Posgrado', 'estudiante', 'Pasaje 3 1'),
(8, 8, 30, 'Masculino', 'Divorciado', 'Primaria', 'ama de casa', 'Callejón 4 5'),
(9, 9, 27, 'Masculino', 'Divorciado', 'Secundaria', 'jubilado', 'Avenida 5 94'),
(10, 10, 15, 'Femenino', 'Conviviente', 'Superior', 'desempleado', 'Calle 1 28'),
(11, 11, 27, 'Masculino', 'Conviviente', 'Posgrado', 'ama de casa', 'Pasaje 6 41'),
(12, 12, 24, 'Masculino', 'Divorciado', 'Posgrado', 'empleado', 'Callejón 4 58'),
(13, 13, 48, 'Femenino', 'Casado', 'Posgrado', 'estudiante', 'Avenida 2 89'),
(14, 14, 16, 'Masculino', 'Soltero', 'Posgrado', 'ama de casa', 'Avenida 2 49'),
(15, 15, 39, 'Femenino', 'Casado', 'Superior', 'ama de casa', 'Calle 1 85'),
(16, 16, 42, 'Femenino', 'Conviviente', 'Secundaria', 'jubilado', 'Callejón 4 62'),
(17, 17, 38, 'Femenino', 'Casado', 'Superior', 'estudiante', 'Calle 1 59'),
(18, 18, 35, 'Femenino', 'Viudo', 'Secundaria', 'ama de casa', 'Avenida 5 50'),
(19, 19, 36, 'Masculino', 'Divorciado', 'Posgrado', 'desempleado', 'Avenida 2 24'),
(20, 20, 35, 'Masculino', 'Viudo', 'Secundaria', 'empleado', 'Calle 1 79'),
(21, 21, 45, 'Masculino', 'Viudo', 'Superior', 'empleado', 'Avenida 5 92'),
(22, 22, 53, 'Femenino', 'Soltero', 'Superior', 'desempleado', 'Pasaje 6 57'),
(23, 23, 30, 'Femenino', 'Casado', 'Primaria', 'empleado', 'Avenida 5 19'),
(24, 24, 37, 'Masculino', 'Viudo', 'Superior', 'jubilado', 'Avenida 5 17'),
(25, 25, 43, 'Masculino', 'Soltero', 'Secundaria', 'ama de casa', 'Pasaje 3 70'),
(26, 26, 49, 'Masculino', 'Divorciado', 'Superior', 'empleado', 'Avenida 2 32'),
(27, 27, 49, 'Masculino', 'Soltero', 'Primaria', 'ama de casa', 'Callejón 4 33'),
(28, 28, 19, 'Femenino', 'Soltero', 'Primaria', 'estudiante', 'Avenida 5 31'),
(29, 29, 27, 'Femenino', 'Casado', 'Primaria', 'estudiante', 'Callejón 4 23'),
(30, 30, 27, 'Femenino', 'Casado', 'Primaria', 'ama de casa', 'Callejón 4 10'),
(31, 31, 31, 'Femenino', 'Conviviente', 'Primaria', 'empleado', 'Calle 1 11'),
(32, 32, 24, 'Masculino', 'Viudo', 'Posgrado', 'jubilado', 'Pasaje 3 98'),
(33, 33, 38, 'Femenino', 'Viudo', 'Secundaria', 'jubilado', 'Callejón 4 75'),
(34, 34, 31, 'Femenino', 'Viudo', 'Secundaria', 'estudiante', 'Calle 1 48'),
(35, 35, 18, 'Femenino', 'Viudo', 'Secundaria', 'ama de casa', 'Pasaje 3 55'),
(36, 36, 37, 'Masculino', 'Divorciado', 'Primaria', 'jubilado', 'Avenida 5 36'),
(37, 37, 22, 'Femenino', 'Divorciado', 'Primaria', 'desempleado', 'Callejón 4 99'),
(38, 38, 25, 'Masculino', 'Conviviente', 'Superior', 'empleado', 'Callejón 4 14'),
(39, 39, 46, 'Masculino', 'Divorciado', 'Superior', 'ama de casa', 'Callejón 4 87'),
(40, 40, 28, 'Masculino', 'Soltero', 'Superior', 'jubilado', 'Pasaje 6 61'),
(41, 41, 51, 'Femenino', 'Casado', 'Posgrado', 'empleado', 'Avenida 2 19'),
(42, 42, 23, 'Femenino', 'Soltero', 'Secundaria', 'ama de casa', 'Avenida 5 62'),
(43, 43, 24, 'Masculino', 'Soltero', 'Superior', 'jubilado', 'Avenida 2 97'),
(44, 44, 40, 'Femenino', 'Soltero', 'Secundaria', 'estudiante', 'Avenida 2 52'),
(45, 45, 56, 'Masculino', 'Divorciado', 'Secundaria', 'jubilado', 'Callejón 4 7'),
(46, 46, 23, 'Masculino', 'Casado', 'Superior', 'ama de casa', 'Calle 1 95'),
(47, 47, 39, 'Masculino', 'Viudo', 'Superior', 'empleado', 'Avenida 5 44'),
(48, 48, 42, 'Femenino', 'Divorciado', 'Secundaria', 'empleado', 'Pasaje 6 27'),
(49, 49, 39, 'Masculino', 'Conviviente', 'Secundaria', 'desempleado', 'Pasaje 3 57'),
(50, 50, 34, 'Masculino', 'Divorciado', 'Secundaria', 'desempleado', 'Avenida 2 96'),
(51, 51, 37, 'Masculino', 'Divorciado', 'Superior', 'desempleado', 'Avenida 2 65'),
(52, 52, 45, 'Femenino', 'Viudo', 'Posgrado', 'jubilado', 'Pasaje 3 95'),
(53, 53, 39, 'Masculino', 'Casado', 'Superior', 'estudiante', 'Calle 1 4'),
(54, 54, 42, 'Masculino', 'Casado', 'Superior', 'jubilado', 'Pasaje 6 96'),
(55, 55, 31, 'Femenino', 'Casado', 'Posgrado', 'jubilado', 'Callejón 4 27'),
(56, 56, 25, 'Masculino', 'Conviviente', 'Primaria', 'empleado', 'Pasaje 6 16'),
(57, 57, 27, 'Femenino', 'Divorciado', 'Primaria', 'estudiante', 'Avenida 5 57'),
(58, 58, 47, 'Femenino', 'Soltero', 'Secundaria', 'desempleado', 'Avenida 5 72'),
(59, 59, 23, 'Femenino', 'Casado', 'Primaria', 'empleado', 'Pasaje 3 59'),
(60, 60, 21, 'Femenino', 'Conviviente', 'Secundaria', 'ama de casa', 'Calle 1 37'),
(61, 61, 31, 'Femenino', 'Conviviente', 'Posgrado', 'desempleado', 'Pasaje 3 19'),
(62, 62, 58, 'Femenino', 'Viudo', 'Secundaria', 'ama de casa', 'Pasaje 6 13'),
(63, 63, 30, 'Masculino', 'Conviviente', 'Superior', 'ama de casa', 'Avenida 2 18'),
(64, 64, 38, 'Femenino', 'Casado', 'Primaria', 'ama de casa', 'Calle 1 13'),
(65, 65, 33, 'Masculino', 'Casado', 'Secundaria', 'estudiante', 'Avenida 5 30'),
(66, 66, 35, 'Femenino', 'Conviviente', 'Secundaria', 'desempleado', 'Avenida 2 27'),
(67, 67, 32, 'Masculino', 'Divorciado', 'Posgrado', 'jubilado', 'Avenida 5 57'),
(68, 68, 32, 'Femenino', 'Conviviente', 'Superior', 'estudiante', 'Avenida 2 3'),
(69, 69, 33, 'Masculino', 'Divorciado', 'Secundaria', 'jubilado', 'Avenida 5 59'),
(70, 70, 48, 'Masculino', 'Conviviente', 'Superior', 'jubilado', 'Pasaje 6 75'),
(71, 71, 23, 'Masculino', 'Divorciado', 'Secundaria', 'ama de casa', 'Callejón 4 50'),
(72, 72, 38, 'Femenino', 'Divorciado', 'Primaria', 'ama de casa', 'Avenida 2 75'),
(73, 73, 38, 'Femenino', 'Casado', 'Posgrado', 'empleado', 'Pasaje 3 49'),
(74, 74, 38, 'Masculino', 'Conviviente', 'Secundaria', 'jubilado', 'Pasaje 6 11'),
(75, 75, 35, 'Femenino', 'Divorciado', 'Secundaria', 'ama de casa', 'Avenida 2 58'),
(76, 76, 36, 'Masculino', 'Conviviente', 'Secundaria', 'desempleado', 'Calle 1 46'),
(77, 77, 37, 'Femenino', 'Viudo', 'Secundaria', 'desempleado', 'Callejón 4 75'),
(78, 78, 18, 'Masculino', 'Conviviente', 'Primaria', 'jubilado', 'Avenida 5 89'),
(79, 79, 23, 'Femenino', 'Soltero', 'Posgrado', 'ama de casa', 'Avenida 2 82'),
(80, 80, 37, 'Masculino', 'Soltero', 'Posgrado', 'ama de casa', 'Pasaje 6 52'),
(81, 81, 22, 'Masculino', 'Casado', 'Primaria', 'ama de casa', 'Avenida 2 95'),
(82, 82, 43, 'Femenino', 'Conviviente', 'Primaria', 'empleado', 'Calle 1 91'),
(83, 83, 35, 'Femenino', 'Casado', 'Primaria', 'estudiante', 'Calle 1 12'),
(84, 84, 41, 'Femenino', 'Conviviente', 'Posgrado', 'estudiante', 'Callejón 4 29'),
(85, 85, 46, 'Masculino', 'Soltero', 'Primaria', 'estudiante', 'Callejón 4 43'),
(86, 86, 37, 'Masculino', 'Conviviente', 'Posgrado', 'jubilado', 'Avenida 5 97'),
(87, 87, 20, 'Masculino', 'Soltero', 'Posgrado', 'jubilado', 'Avenida 2 13'),
(88, 88, 51, 'Femenino', 'Conviviente', 'Secundaria', 'jubilado', 'Avenida 2 71'),
(89, 89, 31, 'Femenino', 'Divorciado', 'Secundaria', 'desempleado', 'Callejón 4 44'),
(90, 90, 50, 'Femenino', 'Divorciado', 'Posgrado', 'empleado', 'Avenida 5 18'),
(91, 91, 52, 'Femenino', 'Divorciado', 'Posgrado', 'estudiante', 'Pasaje 6 15'),
(92, 92, 59, 'Masculino', 'Soltero', 'Primaria', 'desempleado', 'Callejón 4 81'),
(93, 93, 50, 'Masculino', 'Viudo', 'Primaria', 'jubilado', 'Avenida 2 52'),
(94, 94, 23, 'Femenino', 'Viudo', 'Primaria', 'ama de casa', 'Calle 1 5'),
(95, 95, 47, 'Masculino', 'Viudo', 'Primaria', 'ama de casa', 'Callejón 4 12'),
(96, 96, 51, 'Masculino', 'Divorciado', 'Secundaria', 'estudiante', 'Pasaje 6 74'),
(97, 97, 40, 'Femenino', 'Soltero', 'Posgrado', 'desempleado', 'Avenida 2 15'),
(98, 98, 18, 'Masculino', 'Soltero', 'Secundaria', 'jubilado', 'Avenida 2 56'),
(99, 99, 41, 'Masculino', 'Soltero', 'Secundaria', 'desempleado', 'Pasaje 3 26'),
(100, 100, 59, 'Masculino', 'Divorciado', 'Primaria', 'empleado', 'Calle 1 71'),
(101, 101, 19, 'Femenino', 'Viudo', 'Posgrado', 'ama de casa', 'Avenida 5 15'),
(102, 102, 28, 'Femenino', 'Divorciado', 'Primaria', 'empleado', 'Calle 1 2'),
(103, 103, 17, 'Masculino', 'Casado', 'Superior', 'ama de casa', 'Avenida 5 97'),
(104, 104, 59, 'Masculino', 'Soltero', 'Primaria', 'ama de casa', 'Callejón 4 93'),
(105, 105, 20, 'Femenino', 'Soltero', 'Primaria', 'jubilado', 'Callejón 4 29'),
(106, 106, 28, 'Femenino', 'Divorciado', 'Primaria', 'estudiante', 'Avenida 5 7'),
(107, 107, 59, 'Femenino', 'Soltero', 'Primaria', 'desempleado', 'Calle 1 36'),
(108, 108, 25, 'Masculino', 'Casado', 'Posgrado', 'ama de casa', 'Avenida 2 49'),
(109, 109, 51, 'Femenino', 'Conviviente', 'Secundaria', 'jubilado', 'Calle 1 89'),
(110, 110, 32, 'Masculino', 'Viudo', 'Posgrado', 'empleado', 'Avenida 2 21'),
(111, 111, 23, 'Masculino', 'Soltero', 'Superior', 'jubilado', 'Callejón 4 52'),
(112, 112, 39, 'Masculino', 'Soltero', 'Primaria', 'estudiante', 'Calle 1 85'),
(113, 113, 44, 'Masculino', 'Conviviente', 'Primaria', 'ama de casa', 'Avenida 2 33'),
(114, 114, 20, 'Masculino', 'Soltero', 'Posgrado', 'estudiante', 'Pasaje 6 88'),
(115, 115, 49, 'Femenino', 'Casado', 'Posgrado', 'empleado', 'Calle 1 64'),
(116, 116, 34, 'Femenino', 'Divorciado', 'Posgrado', 'estudiante', 'Callejón 4 86'),
(117, 117, 41, 'Femenino', 'Casado', 'Superior', 'empleado', 'Avenida 2 66'),
(118, 118, 29, 'Masculino', 'Divorciado', 'Secundaria', 'estudiante', 'Avenida 5 77'),
(119, 119, 20, 'Masculino', 'Soltero', 'Secundaria', 'ama de casa', 'Callejón 4 20'),
(120, 120, 34, 'Femenino', 'Divorciado', 'Superior', 'desempleado', 'Callejón 4 5'),
(121, 121, 53, 'Masculino', 'Conviviente', 'Posgrado', 'estudiante', 'Pasaje 6 89'),
(122, 122, 19, 'Masculino', 'Viudo', 'Superior', 'desempleado', 'Calle 1 63'),
(123, 123, 30, 'Masculino', 'Soltero', 'Posgrado', 'desempleado', 'Pasaje 3 19'),
(124, 124, 21, 'Femenino', 'Divorciado', 'Primaria', 'jubilado', 'Callejón 4 61'),
(125, 125, 19, 'Masculino', 'Soltero', 'Primaria', 'desempleado', 'Callejón 4 62'),
(126, 126, 56, 'Masculino', 'Casado', 'Primaria', 'empleado', 'Pasaje 6 56'),
(127, 127, 20, 'Femenino', 'Conviviente', 'Posgrado', 'desempleado', 'Avenida 2 83'),
(128, 128, 55, 'Femenino', 'Casado', 'Secundaria', 'ama de casa', 'Callejón 4 67'),
(129, 129, 26, 'Masculino', 'Divorciado', 'Secundaria', 'jubilado', 'Pasaje 6 96'),
(130, 130, 34, 'Masculino', 'Viudo', 'Secundaria', 'ama de casa', 'Callejón 4 89'),
(131, 131, 16, 'Masculino', 'Divorciado', 'Superior', 'empleado', 'Calle 1 94'),
(132, 132, 56, 'Femenino', 'Soltero', 'Posgrado', 'ama de casa', 'Avenida 2 83'),
(133, 133, 59, 'Masculino', 'Viudo', 'Posgrado', 'estudiante', 'Calle 1 86'),
(134, 134, 37, 'Femenino', 'Casado', 'Superior', 'empleado', 'Calle 1 34'),
(135, 135, 19, 'Masculino', 'Divorciado', 'Superior', 'empleado', 'Avenida 5 31'),
(136, 136, 15, 'Masculino', 'Conviviente', 'Secundaria', 'ama de casa', 'Avenida 5 30'),
(137, 137, 30, 'Masculino', 'Casado', 'Secundaria', 'jubilado', 'Calle 1 86'),
(138, 138, 15, 'Masculino', 'Divorciado', 'Superior', 'jubilado', 'Calle 1 53'),
(139, 139, 27, 'Masculino', 'Casado', 'Primaria', 'estudiante', 'Callejón 4 68'),
(140, 140, 57, 'Femenino', 'Conviviente', 'Posgrado', 'estudiante', 'Pasaje 6 81'),
(141, 141, 18, 'Masculino', 'Soltero', 'Posgrado', 'jubilado', 'Callejón 4 29'),
(142, 142, 28, 'Femenino', 'Conviviente', 'Secundaria', 'desempleado', 'Calle 1 43'),
(143, 143, 31, 'Femenino', 'Casado', 'Superior', 'ama de casa', 'Pasaje 6 19'),
(144, 144, 37, 'Femenino', 'Conviviente', 'Posgrado', 'jubilado', 'Pasaje 3 13'),
(145, 145, 49, 'Masculino', 'Soltero', 'Posgrado', 'jubilado', 'Calle 1 15'),
(146, 146, 22, 'Femenino', 'Conviviente', 'Superior', 'ama de casa', 'Avenida 2 73'),
(147, 147, 24, 'Femenino', 'Conviviente', 'Posgrado', 'desempleado', 'Pasaje 6 4'),
(148, 148, 21, 'Masculino', 'Conviviente', 'Posgrado', 'ama de casa', 'Callejón 4 87'),
(149, 149, 49, 'Masculino', 'Soltero', 'Posgrado', 'ama de casa', 'Pasaje 3 75'),
(150, 150, 40, 'Femenino', 'Divorciado', 'Secundaria', 'jubilado', 'Pasaje 6 45'),
(151, 151, 30, 'Masculino', 'Casado', 'Superior', 'empleado', 'Pasaje 3 30'),
(152, 152, 44, 'Femenino', 'Conviviente', 'Posgrado', 'desempleado', 'Avenida 2 59'),
(153, 153, 23, 'Femenino', 'Casado', 'Superior', 'estudiante', 'Avenida 2 38'),
(154, 154, 25, 'Femenino', 'Viudo', 'Secundaria', 'jubilado', 'Pasaje 3 88'),
(155, 155, 51, 'Masculino', 'Divorciado', 'Posgrado', 'jubilado', 'Avenida 5 96'),
(156, 156, 28, 'Femenino', 'Divorciado', 'Secundaria', 'estudiante', 'Pasaje 6 30'),
(157, 157, 19, 'Femenino', 'Conviviente', 'Superior', 'estudiante', 'Avenida 5 96'),
(158, 158, 44, 'Femenino', 'Divorciado', 'Secundaria', 'desempleado', 'Pasaje 6 85'),
(159, 159, 57, 'Femenino', 'Viudo', 'Primaria', 'empleado', 'Avenida 5 92'),
(160, 160, 18, 'Femenino', 'Divorciado', 'Superior', 'estudiante', 'Calle 1 75'),
(161, 161, 22, 'Femenino', 'Casado', 'Secundaria', 'ama de casa', 'Callejón 4 65'),
(162, 162, 28, 'Masculino', 'Viudo', 'Posgrado', 'desempleado', 'Avenida 2 75'),
(163, 163, 32, 'Femenino', 'Conviviente', 'Primaria', 'estudiante', 'Calle 1 76'),
(164, 164, 39, 'Masculino', 'Viudo', 'Superior', 'desempleado', 'Pasaje 3 44'),
(165, 165, 33, 'Masculino', 'Divorciado', 'Secundaria', 'empleado', 'Avenida 5 7'),
(166, 166, 53, 'Masculino', 'Viudo', 'Posgrado', 'jubilado', 'Avenida 2 84'),
(167, 167, 37, 'Femenino', 'Divorciado', 'Secundaria', 'jubilado', 'Avenida 2 73'),
(168, 168, 47, 'Femenino', 'Soltero', 'Superior', 'empleado', 'Pasaje 6 29'),
(169, 169, 50, 'Masculino', 'Divorciado', 'Superior', 'estudiante', 'Callejón 4 5'),
(170, 170, 34, 'Masculino', 'Viudo', 'Primaria', 'empleado', 'Pasaje 6 98'),
(171, 171, 37, 'Masculino', 'Soltero', 'Secundaria', 'estudiante', 'Avenida 2 73'),
(172, 172, 30, 'Masculino', 'Soltero', 'Superior', 'desempleado', 'Callejón 4 87'),
(173, 173, 23, 'Masculino', 'Conviviente', 'Primaria', 'estudiante', 'Callejón 4 27'),
(174, 174, 33, 'Femenino', 'Soltero', 'Superior', 'jubilado', 'Avenida 5 39'),
(175, 175, 18, 'Femenino', 'Conviviente', 'Primaria', 'jubilado', 'Calle 1 93'),
(176, 176, 49, 'Femenino', 'Conviviente', 'Posgrado', 'empleado', 'Avenida 2 41'),
(177, 177, 17, 'Masculino', 'Conviviente', 'Primaria', 'ama de casa', 'Avenida 5 8'),
(178, 178, 37, 'Masculino', 'Divorciado', 'Primaria', 'desempleado', 'Avenida 5 63'),
(179, 179, 53, 'Masculino', 'Divorciado', 'Primaria', 'empleado', 'Avenida 2 65'),
(180, 180, 54, 'Masculino', 'Casado', 'Superior', 'ama de casa', 'Pasaje 6 21'),
(181, 181, 58, 'Masculino', 'Viudo', 'Posgrado', 'ama de casa', 'Pasaje 6 93'),
(182, 182, 25, 'Femenino', 'Conviviente', 'Primaria', 'jubilado', 'Pasaje 3 92'),
(183, 183, 34, 'Femenino', 'Soltero', 'Superior', 'ama de casa', 'Avenida 5 14'),
(184, 184, 41, 'Femenino', 'Soltero', 'Posgrado', 'ama de casa', 'Callejón 4 91'),
(185, 185, 54, 'Femenino', 'Soltero', 'Posgrado', 'estudiante', 'Pasaje 3 85'),
(186, 186, 43, 'Masculino', 'Viudo', 'Superior', 'ama de casa', 'Pasaje 3 10'),
(187, 187, 19, 'Femenino', 'Conviviente', 'Superior', 'desempleado', 'Pasaje 3 79'),
(188, 188, 19, 'Femenino', 'Divorciado', 'Superior', 'ama de casa', 'Avenida 2 80'),
(189, 189, 37, 'Femenino', 'Soltero', 'Posgrado', 'jubilado', 'Pasaje 6 86'),
(190, 190, 22, 'Masculino', 'Casado', 'Posgrado', 'empleado', 'Callejón 4 28'),
(191, 191, 43, 'Femenino', 'Conviviente', 'Primaria', 'jubilado', 'Avenida 5 94'),
(192, 192, 33, 'Masculino', 'Viudo', 'Primaria', 'estudiante', 'Avenida 5 24'),
(193, 193, 55, 'Masculino', 'Divorciado', 'Secundaria', 'empleado', 'Pasaje 3 32'),
(194, 194, 48, 'Femenino', 'Casado', 'Secundaria', 'ama de casa', 'Callejón 4 37'),
(195, 195, 18, 'Femenino', 'Viudo', 'Secundaria', 'ama de casa', 'Pasaje 6 92'),
(196, 196, 34, 'Masculino', 'Conviviente', 'Posgrado', 'estudiante', 'Avenida 5 41'),
(197, 197, 15, 'Femenino', 'Casado', 'Secundaria', 'jubilado', 'Pasaje 3 93'),
(198, 198, 22, 'Masculino', 'Conviviente', 'Primaria', 'desempleado', 'Callejón 4 14'),
(199, 199, 38, 'Femenino', 'Casado', 'Superior', 'jubilado', 'Avenida 2 50'),
(200, 200, 54, 'Masculino', 'Casado', 'Superior', 'ama de casa', 'Callejón 4 15');

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
(6, 4, 'Centro de Salud Jerillo', 'cs_jerillo', 'Urbana', 'Jerillo', 'Jr. Principal, Jepelacio', 1);

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

--
-- Volcado de datos para la tabla `vih_factores_riesgo`
--

INSERT INTO `vih_factores_riesgo` (`id_factores_riesgo`, `id_cuestionario`, `uso_preservativos_pre_diagnostico`, `relaciones_sin_proteccion_post_diagnostico`, `numero_parejas_ultimo_anio`, `relaciones_mismo_sexo`, `uso_drogas_inyectables`, `transfusiones_ultimos_5_anios`, `antecedentes_its`, `detalle_its_previas`, `relaciones_ocasionales_post_diagnostico`) VALUES
(1, 1, 'Siempre', 2, 0, 2, 1, 0, 2, 'sifilis', 0),
(2, 2, 'A_veces', 2, 2, 0, 1, 0, 2, 'hepatitis', 0),
(3, 3, 'Siempre', 2, 0, 0, 2, 0, 2, 'clamidia', 0),
(4, 4, 'A_veces', 2, 0, 2, 1, 0, 2, 'hepatitis', 0),
(5, 5, 'A_veces', 0, 0, 2, 2, 0, 2, 'gonorrea', 0),
(6, 6, 'Nunca', 0, 0, 2, 2, 0, 0, '', 0),
(7, 7, 'A_veces', 2, 0, 2, 2, 0, 0, '', 0),
(8, 8, 'Nunca', 0, 1, 0, 1, 0, 2, 'sifilis', 0),
(9, 9, 'Siempre', 0, 0, 2, 2, 0, 2, 'gonorrea', 0),
(10, 10, 'Siempre', 2, 0, 2, 2, 0, 0, '', 0),
(11, 11, 'Siempre', 0, 2, 0, 2, 0, 2, 'hepatitis', 0),
(12, 12, 'Siempre', 2, 0, 2, 1, 0, 2, 'herpes', 0),
(13, 13, 'Nunca', 0, 2, 2, 1, 0, 2, 'gonorrea', 0),
(14, 14, 'Siempre', 2, 1, 2, 1, 0, 0, '', 0),
(15, 15, 'A_veces', 2, 0, 2, 1, 0, 2, 'hepatitis', 0),
(16, 16, 'A_veces', 2, 2, 2, 1, 0, 0, '', 0),
(17, 17, 'A_veces', 2, 2, 0, 2, 0, 2, 'herpes', 0),
(18, 18, 'Nunca', 0, 1, 2, 1, 0, 0, '', 0),
(19, 19, 'Siempre', 2, 0, 2, 1, 0, 0, '', 0),
(20, 20, 'Siempre', 2, 0, 2, 1, 0, 2, 'hepatitis', 0),
(21, 21, 'Siempre', 2, 2, 2, 2, 0, 0, '', 0),
(22, 22, 'Nunca', 0, 0, 2, 1, 0, 2, 'herpes', 0),
(23, 23, 'A_veces', 2, 2, 0, 1, 0, 0, '', 0),
(24, 24, 'A_veces', 0, 0, 2, 2, 0, 2, 'clamidia', 0),
(25, 25, 'Siempre', 2, 2, 0, 1, 0, 2, 'sifilis', 0),
(26, 26, 'A_veces', 0, 0, 0, 2, 0, 0, '', 0),
(27, 27, 'A_veces', 0, 1, 2, 2, 0, 2, 'gonorrea', 0),
(28, 28, 'Nunca', 2, 0, 2, 2, 0, 2, 'herpes', 0),
(29, 29, 'Nunca', 0, 0, 2, 2, 0, 0, '', 0),
(30, 30, 'Nunca', 2, 1, 2, 2, 0, 2, 'herpes', 0),
(31, 31, 'Nunca', 2, 0, 0, 1, 0, 2, 'clamidia', 0),
(32, 32, 'Siempre', 2, 1, 2, 2, 0, 0, '', 0),
(33, 33, 'Nunca', 0, 0, 2, 2, 0, 0, '', 0),
(34, 34, 'A_veces', 0, 2, 2, 1, 0, 2, 'sifilis', 0),
(35, 35, 'Siempre', 2, 2, 2, 2, 0, 2, 'clamidia', 0),
(36, 36, 'A_veces', 2, 0, 2, 1, 0, 0, '', 0),
(37, 37, 'A_veces', 0, 0, 2, 1, 0, 0, '', 0),
(38, 38, 'A_veces', 2, 0, 0, 1, 0, 2, 'clamidia', 0),
(39, 39, 'Nunca', 2, 2, 0, 2, 0, 0, '', 0),
(40, 40, 'Nunca', 2, 0, 2, 2, 0, 2, 'clamidia', 0),
(41, 41, 'Siempre', 0, 2, 2, 2, 0, 2, 'herpes', 0),
(42, 42, 'Siempre', 0, 1, 2, 1, 0, 2, 'clamidia', 0),
(43, 43, 'Nunca', 0, 2, 0, 2, 0, 2, 'hepatitis', 0),
(44, 44, 'A_veces', 2, 2, 2, 2, 0, 2, 'hepatitis', 0),
(45, 45, 'Siempre', 2, 1, 0, 2, 0, 0, '', 0),
(46, 46, 'Nunca', 2, 2, 2, 1, 0, 0, '', 0),
(47, 47, 'Nunca', 0, 0, 2, 1, 0, 0, '', 0),
(48, 48, 'Nunca', 2, 0, 2, 2, 0, 0, '', 0),
(49, 49, 'A_veces', 2, 2, 2, 2, 0, 2, 'clamidia', 0),
(50, 50, 'Nunca', 2, 0, 0, 2, 0, 2, 'hepatitis', 0),
(51, 51, 'Nunca', 2, 2, 0, 2, 0, 2, 'gonorrea', 0),
(52, 52, 'Nunca', 0, 0, 2, 1, 0, 2, 'herpes', 0),
(53, 53, 'Nunca', 0, 0, 2, 1, 0, 0, '', 0),
(54, 54, 'Siempre', 2, 2, 0, 1, 0, 2, 'clamidia', 0),
(55, 55, 'Siempre', 0, 0, 0, 1, 0, 2, 'clamidia', 0),
(56, 56, 'Nunca', 0, 2, 0, 2, 0, 0, '', 0),
(57, 57, 'A_veces', 2, 0, 0, 2, 0, 0, '', 0),
(58, 58, 'Siempre', 2, 0, 2, 2, 0, 0, '', 0),
(59, 59, 'Nunca', 0, 1, 0, 1, 0, 0, '', 0),
(60, 60, 'Siempre', 2, 1, 2, 2, 0, 2, 'sifilis', 0),
(61, 61, 'Siempre', 0, 2, 0, 1, 0, 2, 'clamidia', 0),
(62, 62, 'A_veces', 2, 1, 0, 1, 0, 0, '', 0),
(63, 63, 'Nunca', 0, 2, 0, 2, 0, 2, 'clamidia', 0),
(64, 64, 'Nunca', 2, 1, 0, 2, 0, 2, 'herpes', 0),
(65, 65, 'A_veces', 0, 0, 0, 2, 0, 2, 'clamidia', 0),
(66, 66, 'A_veces', 0, 2, 2, 1, 0, 0, '', 0),
(67, 67, 'Nunca', 0, 2, 2, 2, 0, 2, 'hepatitis', 0),
(68, 68, 'Nunca', 2, 0, 0, 1, 0, 0, '', 0),
(69, 69, 'A_veces', 0, 2, 0, 2, 0, 2, 'herpes', 0),
(70, 70, 'Siempre', 0, 2, 2, 1, 0, 2, 'herpes', 0),
(71, 71, 'Siempre', 2, 1, 0, 1, 0, 2, 'clamidia', 0),
(72, 72, 'A_veces', 2, 2, 0, 2, 0, 0, '', 0),
(73, 73, 'Siempre', 0, 0, 2, 1, 0, 2, 'hepatitis', 0),
(74, 74, 'A_veces', 0, 1, 0, 1, 0, 0, '', 0),
(75, 75, 'Siempre', 2, 1, 0, 2, 0, 0, '', 0),
(76, 76, 'Siempre', 2, 0, 2, 1, 0, 0, '', 0),
(77, 77, 'Nunca', 2, 0, 2, 2, 0, 2, 'gonorrea', 0),
(78, 78, 'Nunca', 2, 1, 2, 1, 0, 2, 'sifilis', 0),
(79, 79, 'Siempre', 2, 2, 0, 2, 0, 2, 'hepatitis', 0),
(80, 80, 'Siempre', 0, 1, 2, 2, 0, 2, 'clamidia', 0),
(81, 81, 'Nunca', 2, 0, 2, 1, 0, 0, '', 0),
(82, 82, 'Nunca', 0, 1, 2, 1, 0, 0, '', 0),
(83, 83, 'Nunca', 0, 0, 2, 1, 0, 0, '', 0),
(84, 84, 'A_veces', 0, 1, 2, 1, 0, 2, 'hepatitis', 0),
(85, 85, 'Siempre', 2, 2, 2, 1, 0, 0, '', 0),
(86, 86, 'Nunca', 0, 1, 0, 2, 0, 2, 'clamidia', 0),
(87, 87, 'Siempre', 0, 1, 0, 1, 0, 0, '', 0),
(88, 88, 'A_veces', 2, 0, 2, 2, 0, 2, 'clamidia', 0),
(89, 89, 'A_veces', 0, 0, 2, 2, 0, 2, 'clamidia', 0),
(90, 90, 'Nunca', 0, 0, 2, 1, 0, 0, '', 0),
(91, 91, 'A_veces', 2, 1, 0, 2, 0, 0, '', 0),
(92, 92, 'Siempre', 0, 2, 0, 2, 0, 0, '', 0),
(93, 93, 'Nunca', 0, 0, 0, 2, 0, 0, '', 0),
(94, 94, 'Siempre', 0, 0, 0, 2, 0, 2, 'herpes', 0),
(95, 95, 'Siempre', 2, 1, 0, 1, 0, 0, '', 0),
(96, 96, 'A_veces', 2, 0, 0, 2, 0, 0, '', 0),
(97, 97, 'A_veces', 2, 2, 0, 1, 0, 0, '', 0),
(98, 98, 'A_veces', 0, 2, 0, 1, 0, 2, 'hepatitis', 0),
(99, 99, 'A_veces', 0, 0, 0, 2, 0, 2, 'hepatitis', 0),
(100, 100, 'A_veces', 2, 0, 2, 1, 0, 0, '', 0),
(101, 101, 'Nunca', 0, 1, 2, 1, 0, 2, 'sifilis', 0),
(102, 102, 'Siempre', 0, 2, 2, 1, 0, 0, '', 0),
(103, 103, 'Siempre', 2, 2, 2, 2, 0, 2, 'gonorrea', 0),
(104, 104, 'Siempre', 2, 0, 0, 1, 0, 2, 'clamidia', 0),
(105, 105, 'Siempre', 0, 1, 0, 1, 0, 2, 'sifilis', 0),
(106, 106, 'A_veces', 0, 2, 2, 1, 0, 2, 'herpes', 0),
(107, 107, 'Siempre', 0, 2, 0, 2, 0, 0, '', 0),
(108, 108, 'Nunca', 2, 1, 2, 1, 0, 0, '', 0),
(109, 109, 'Nunca', 2, 1, 0, 2, 0, 0, '', 0),
(110, 110, 'Siempre', 2, 2, 2, 2, 0, 2, 'sifilis', 0),
(111, 111, 'Siempre', 2, 2, 0, 2, 0, 0, '', 0),
(112, 112, 'Nunca', 0, 1, 0, 2, 0, 0, '', 0),
(113, 113, 'Nunca', 2, 2, 2, 2, 0, 0, '', 0),
(114, 114, 'A_veces', 2, 0, 0, 2, 0, 2, 'hepatitis', 0),
(115, 115, 'Nunca', 2, 0, 2, 1, 0, 2, 'hepatitis', 0),
(116, 116, 'A_veces', 2, 1, 2, 2, 0, 2, 'clamidia', 0),
(117, 117, 'A_veces', 2, 1, 2, 1, 0, 0, '', 0),
(118, 118, 'A_veces', 0, 1, 2, 1, 0, 0, '', 0),
(119, 119, 'A_veces', 0, 0, 0, 2, 0, 0, '', 0),
(120, 120, 'A_veces', 2, 2, 0, 1, 0, 2, 'sifilis', 0),
(121, 121, 'Siempre', 0, 0, 0, 1, 0, 2, 'hepatitis', 0),
(122, 122, 'Nunca', 2, 2, 2, 1, 0, 0, '', 0),
(123, 123, 'A_veces', 2, 0, 0, 1, 0, 2, 'hepatitis', 0),
(124, 124, 'Nunca', 0, 2, 2, 2, 0, 2, 'gonorrea', 0),
(125, 125, 'Nunca', 0, 0, 0, 1, 0, 2, 'hepatitis', 0),
(126, 126, 'A_veces', 2, 1, 0, 2, 0, 2, 'gonorrea', 0),
(127, 127, 'Siempre', 2, 0, 0, 1, 0, 0, '', 0),
(128, 128, 'A_veces', 2, 2, 2, 1, 0, 2, 'hepatitis', 0),
(129, 129, 'Siempre', 0, 0, 0, 2, 0, 2, 'herpes', 0),
(130, 130, 'Nunca', 2, 0, 0, 1, 0, 2, 'clamidia', 0),
(131, 131, 'Siempre', 2, 0, 2, 1, 0, 2, 'sifilis', 0),
(132, 132, 'Siempre', 2, 1, 0, 1, 0, 0, '', 0),
(133, 133, 'Siempre', 0, 0, 2, 2, 0, 0, '', 0),
(134, 134, 'Nunca', 2, 1, 0, 1, 0, 2, 'clamidia', 0),
(135, 135, 'Nunca', 2, 1, 2, 2, 0, 2, 'sifilis', 0),
(136, 136, 'Siempre', 0, 0, 2, 1, 0, 2, 'herpes', 0),
(137, 137, 'Siempre', 2, 0, 0, 2, 0, 2, 'sifilis', 0),
(138, 138, 'A_veces', 2, 0, 2, 2, 0, 2, 'sifilis', 0),
(139, 139, 'Siempre', 0, 2, 2, 1, 0, 2, 'hepatitis', 0),
(140, 140, 'A_veces', 2, 0, 2, 1, 0, 0, '', 0),
(141, 141, 'Siempre', 0, 1, 2, 2, 0, 2, 'sifilis', 0),
(142, 142, 'A_veces', 0, 0, 2, 2, 0, 0, '', 0),
(143, 143, 'Nunca', 2, 2, 2, 1, 0, 0, '', 0),
(144, 144, 'Siempre', 2, 0, 0, 2, 0, 2, 'gonorrea', 0),
(145, 145, 'Siempre', 2, 2, 2, 1, 0, 0, '', 0),
(146, 146, 'Siempre', 2, 2, 2, 1, 0, 0, '', 0),
(147, 147, 'Siempre', 0, 0, 0, 1, 0, 0, '', 0),
(148, 148, 'A_veces', 2, 1, 0, 1, 0, 0, '', 0),
(149, 149, 'Siempre', 0, 2, 0, 2, 0, 0, '', 0),
(150, 150, 'Nunca', 2, 0, 0, 1, 0, 0, '', 0),
(151, 151, 'Nunca', 2, 0, 0, 2, 0, 2, 'herpes', 0),
(152, 152, 'Siempre', 2, 1, 0, 1, 0, 0, '', 0),
(153, 153, 'Nunca', 0, 2, 0, 2, 0, 0, '', 0),
(154, 154, 'Siempre', 2, 2, 2, 1, 0, 0, '', 0),
(155, 155, 'Siempre', 2, 0, 2, 2, 0, 2, 'sifilis', 0),
(156, 156, 'Nunca', 2, 0, 0, 2, 0, 0, '', 0),
(157, 157, 'Siempre', 2, 1, 2, 1, 0, 2, 'clamidia', 0),
(158, 158, 'Nunca', 0, 1, 2, 1, 0, 0, '', 0),
(159, 159, 'A_veces', 2, 2, 2, 1, 0, 2, 'sifilis', 0),
(160, 160, 'Siempre', 0, 2, 0, 1, 0, 2, 'hepatitis', 0),
(161, 161, 'A_veces', 0, 0, 0, 2, 0, 0, '', 0),
(162, 162, 'Nunca', 0, 2, 2, 1, 0, 0, '', 0),
(163, 163, 'A_veces', 0, 1, 0, 2, 0, 2, 'sifilis', 0),
(164, 164, 'A_veces', 0, 1, 2, 2, 0, 0, '', 0),
(165, 165, 'Nunca', 0, 0, 2, 1, 0, 2, 'clamidia', 0),
(166, 166, 'A_veces', 2, 1, 2, 2, 0, 2, 'hepatitis', 0),
(167, 167, 'A_veces', 0, 1, 2, 2, 0, 2, 'clamidia', 0),
(168, 168, 'Nunca', 0, 1, 0, 2, 0, 2, 'gonorrea', 0),
(169, 169, 'A_veces', 0, 1, 0, 2, 0, 2, 'hepatitis', 0),
(170, 170, 'Nunca', 2, 0, 0, 1, 0, 0, '', 0),
(171, 171, 'A_veces', 2, 0, 2, 1, 0, 2, 'herpes', 0),
(172, 172, 'Nunca', 0, 2, 0, 1, 0, 2, 'hepatitis', 0),
(173, 173, 'Nunca', 2, 1, 2, 1, 0, 0, '', 0),
(174, 174, 'A_veces', 0, 2, 0, 2, 0, 2, 'herpes', 0),
(175, 175, 'A_veces', 0, 0, 2, 2, 0, 0, '', 0),
(176, 176, 'A_veces', 2, 0, 2, 1, 0, 0, '', 0),
(177, 177, 'Siempre', 0, 0, 2, 1, 0, 0, '', 0),
(178, 178, 'Siempre', 2, 0, 0, 1, 0, 2, 'herpes', 0),
(179, 179, 'Siempre', 2, 0, 0, 2, 0, 2, 'gonorrea', 0),
(180, 180, 'Nunca', 0, 0, 0, 1, 0, 2, 'clamidia', 0),
(181, 181, 'A_veces', 0, 0, 0, 1, 0, 0, '', 0),
(182, 182, 'Nunca', 2, 1, 2, 1, 0, 2, 'hepatitis', 0),
(183, 183, 'Siempre', 0, 2, 0, 2, 0, 0, '', 0),
(184, 184, 'A_veces', 0, 0, 0, 2, 0, 2, 'herpes', 0),
(185, 185, 'Nunca', 0, 1, 2, 2, 0, 0, '', 0),
(186, 186, 'A_veces', 2, 1, 2, 2, 0, 2, 'clamidia', 0),
(187, 187, 'Nunca', 2, 2, 2, 2, 0, 2, 'clamidia', 0),
(188, 188, 'A_veces', 0, 0, 0, 2, 0, 2, 'herpes', 0),
(189, 189, 'Siempre', 2, 2, 2, 2, 0, 0, '', 0),
(190, 190, 'Siempre', 2, 0, 2, 2, 0, 0, '', 0),
(191, 191, 'A_veces', 2, 1, 2, 1, 0, 2, 'clamidia', 0),
(192, 192, 'Nunca', 2, 1, 0, 1, 0, 2, 'clamidia', 0),
(193, 193, 'Siempre', 2, 1, 2, 2, 0, 0, '', 0),
(194, 194, 'Siempre', 0, 1, 0, 2, 0, 0, '', 0),
(195, 195, 'Siempre', 0, 2, 0, 1, 0, 0, '', 0),
(196, 196, 'A_veces', 0, 0, 2, 2, 0, 2, 'herpes', 0),
(197, 197, 'A_veces', 2, 0, 2, 2, 0, 0, '', 0),
(198, 198, 'Nunca', 2, 2, 0, 2, 0, 2, 'clamidia', 0),
(199, 199, 'Nunca', 0, 0, 2, 1, 0, 0, '', 0),
(200, 200, 'Nunca', 2, 1, 2, 1, 0, 2, 'herpes', 0);

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

--
-- Volcado de datos para la tabla `vih_informacion_clinica`
--

INSERT INTO `vih_informacion_clinica` (`id_clinica`, `id_cuestionario`, `fecha_diagnostico_vih`, `tipo_prueba_diagnostico`, `otro_tipo_prueba`, `recibe_tar`, `fecha_inicio_tar`, `ultimo_cd4`, `unidad_cd4`, `ultima_carga_viral`, `unidad_carga_viral`, `presenta_its_actual`, `conoce_its_actual`) VALUES
(1, 1, '2020-08-03', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(2, 2, '2022-03-20', 'Prueba rapida', '', 2, '2020-02-18', 408, 'células/μL', 402, 'copias/mL', 2, 'Si'),
(3, 3, '2023-01-06', 'Western blot', '', 2, '2021-11-28', 463, 'células/μL', 783, 'copias/mL', 2, 'Si'),
(4, 4, '2022-11-30', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(5, 5, '2020-12-22', 'Elisa', '', 2, '2021-06-03', 642, 'células/μL', 899, 'copias/mL', 1, 'No_sabe'),
(6, 6, '2021-02-20', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(7, 7, '2020-02-17', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(8, 8, '2023-08-18', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(9, 9, '2022-04-23', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(10, 10, '2020-05-18', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(11, 11, '2022-04-06', 'Otro', '', 2, '2022-03-13', 789, 'células/μL', 524, 'copias/mL', 2, 'Si'),
(12, 12, '2022-08-27', 'Western blot', '', 2, '2020-10-15', 446, 'células/μL', 373, 'copias/mL', 1, 'No_sabe'),
(13, 13, '2022-12-05', 'Western blot', '', 2, '2022-01-01', 632, 'células/μL', 233, 'copias/mL', 1, 'No_sabe'),
(14, 14, '2020-02-01', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(15, 15, '2023-10-08', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(16, 16, '2023-10-26', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(17, 17, '2020-05-17', 'Elisa', '', 2, '2023-08-25', 522, 'células/μL', 487, 'copias/mL', 2, 'Si'),
(18, 18, '2022-01-05', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(19, 19, '2021-10-22', 'Western blot', '', 2, '2021-12-16', 320, 'células/μL', 443, 'copias/mL', 2, 'Si'),
(20, 20, '2022-04-15', 'Otro', '', 2, '2022-04-11', 980, 'células/μL', 542, 'copias/mL', 1, 'No_sabe'),
(21, 21, '2021-04-29', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(22, 22, '2023-06-12', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(23, 23, '2023-04-23', 'Elisa', '', 2, '2021-08-24', 650, 'células/μL', 475, 'copias/mL', 0, 'No'),
(24, 24, '2022-04-26', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(25, 25, '2021-03-20', 'Otro', '', 2, '2022-09-11', 324, 'células/μL', 881, 'copias/mL', 1, 'No_sabe'),
(26, 26, '2023-06-03', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(27, 27, '2021-07-01', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(28, 28, '2022-07-07', 'Otro', '', 2, '2022-05-03', 696, 'células/μL', 650, 'copias/mL', 1, 'No_sabe'),
(29, 29, '2023-12-20', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(30, 30, '2021-01-27', 'Elisa', '', 2, '2022-09-10', 852, 'células/μL', 940, 'copias/mL', 1, 'No_sabe'),
(31, 31, '2020-01-01', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(32, 32, '2021-05-30', 'Otro', '', 2, '2022-06-29', 336, 'células/μL', 110, 'copias/mL', 1, 'No_sabe'),
(33, 33, '2020-03-10', 'Western blot', '', 2, '2021-09-16', 307, 'células/μL', 542, 'copias/mL', 2, 'Si'),
(34, 34, '2020-11-02', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(35, 35, '2020-02-06', 'Elisa', '', 2, '2023-02-06', 424, 'células/μL', 700, 'copias/mL', 2, 'Si'),
(36, 36, '2021-10-05', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(37, 37, '2023-05-09', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(38, 38, '2022-08-19', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(39, 39, '2021-10-20', 'Prueba rapida', '', 2, '2023-06-15', 404, 'células/μL', 227, 'copias/mL', 1, 'No_sabe'),
(40, 40, '2023-03-19', 'Prueba rapida', '', 2, '2023-10-03', 444, 'células/μL', 131, 'copias/mL', 1, 'No_sabe'),
(41, 41, '2022-07-11', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(42, 42, '2022-03-14', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(43, 43, '2022-04-19', 'Prueba rapida', '', 2, '2021-09-17', 650, 'células/μL', 450, 'copias/mL', 1, 'No_sabe'),
(44, 44, '2023-07-24', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(45, 45, '2022-05-26', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(46, 46, '2021-03-08', 'Western blot', '', 2, '2020-03-28', 748, 'células/μL', 608, 'copias/mL', 1, 'No_sabe'),
(47, 47, '2023-12-20', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(48, 48, '2022-05-06', 'Elisa', '', 2, '2023-07-23', 420, 'células/μL', 120, 'copias/mL', 2, 'Si'),
(49, 49, '2021-07-20', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(50, 50, '2023-11-22', 'Elisa', '', 2, '2023-11-07', 217, 'células/μL', 301, 'copias/mL', 1, 'No_sabe'),
(51, 51, '2020-11-03', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(52, 52, '2022-12-02', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(53, 53, '2022-02-20', 'Otro', '', 2, '2021-07-15', 295, 'células/μL', 100, 'copias/mL', 2, 'Si'),
(54, 54, '2023-05-18', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(55, 55, '2020-01-10', 'Otro', '', 2, '2023-07-07', 442, 'células/μL', 806, 'copias/mL', 0, 'No'),
(56, 56, '2023-07-13', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(57, 57, '2020-04-27', 'Prueba rapida', '', 2, '2023-11-09', 567, 'células/μL', 833, 'copias/mL', 1, 'No_sabe'),
(58, 58, '2021-05-30', 'Elisa', '', 2, '2023-08-25', 251, 'células/μL', 651, 'copias/mL', 2, 'Si'),
(59, 59, '2021-11-15', 'Otro', '', 2, '2023-03-23', 793, 'células/μL', 203, 'copias/mL', 1, 'No_sabe'),
(60, 60, '2023-09-09', 'Otro', '', 2, '2020-04-19', 971, 'células/μL', 355, 'copias/mL', 0, 'No'),
(61, 61, '2022-01-04', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(62, 62, '2023-08-25', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(63, 63, '2022-09-05', 'Elisa', '', 2, '2023-12-09', 450, 'células/μL', 386, 'copias/mL', 2, 'Si'),
(64, 64, '2021-05-14', 'Western blot', '', 2, '2022-11-24', 279, 'células/μL', 651, 'copias/mL', 2, 'Si'),
(65, 65, '2023-02-16', 'Elisa', '', 2, '2022-05-27', 699, 'células/μL', 539, 'copias/mL', 0, 'No'),
(66, 66, '2021-06-17', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(67, 67, '2021-03-05', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(68, 68, '2020-04-11', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(69, 69, '2023-11-15', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(70, 70, '2023-12-13', 'Elisa', '', 2, '2021-09-08', 603, 'células/μL', 626, 'copias/mL', 2, 'Si'),
(71, 71, '2020-03-02', 'Western blot', '', 2, '2020-08-22', 976, 'células/μL', 132, 'copias/mL', 2, 'Si'),
(72, 72, '2023-08-09', 'Prueba rapida', '', 2, '2021-08-18', 750, 'células/μL', 497, 'copias/mL', 0, 'No'),
(73, 73, '2020-08-19', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(74, 74, '2022-11-02', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(75, 75, '2023-09-19', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(76, 76, '2021-08-08', 'Western blot', '', 2, '2022-03-24', 741, 'células/μL', 658, 'copias/mL', 1, 'No_sabe'),
(77, 77, '2022-10-18', 'Western blot', '', 2, '2022-04-27', 330, 'células/μL', 150, 'copias/mL', 2, 'Si'),
(78, 78, '2020-09-05', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(79, 79, '2021-10-18', 'Western blot', '', 2, '2020-12-28', 610, 'células/μL', 836, 'copias/mL', 1, 'No_sabe'),
(80, 80, '2023-04-04', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(81, 81, '2020-08-12', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(82, 82, '2020-07-05', 'Prueba rapida', '', 2, '2022-11-17', 759, 'células/μL', 451, 'copias/mL', 1, 'No_sabe'),
(83, 83, '2023-01-13', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(84, 84, '2021-10-22', 'Otro', '', 2, '2021-03-11', 556, 'células/μL', 458, 'copias/mL', 1, 'No_sabe'),
(85, 85, '2023-01-06', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(86, 86, '2023-07-01', 'Western blot', '', 2, '2022-03-12', 551, 'células/μL', 329, 'copias/mL', 0, 'No'),
(87, 87, '2023-08-17', 'Western blot', '', 2, '2022-08-25', 201, 'células/μL', 979, 'copias/mL', 1, 'No_sabe'),
(88, 88, '2023-02-04', 'Western blot', '', 2, '2020-01-30', 992, 'células/μL', 874, 'copias/mL', 2, 'Si'),
(89, 89, '2021-04-27', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(90, 90, '2023-11-20', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(91, 91, '2023-04-02', 'Western blot', '', 2, '2021-01-01', 597, 'células/μL', 935, 'copias/mL', 0, 'No'),
(92, 92, '2023-03-23', 'Prueba rapida', '', 2, '2021-02-17', 719, 'células/μL', 198, 'copias/mL', 2, 'Si'),
(93, 93, '2020-02-09', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(94, 94, '2023-02-14', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(95, 95, '2021-10-11', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(96, 96, '2021-05-06', 'Prueba rapida', '', 2, '2021-05-05', 940, 'células/μL', 387, 'copias/mL', 2, 'Si'),
(97, 97, '2020-08-19', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(98, 98, '2020-08-10', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(99, 99, '2023-07-27', 'Western blot', '', 2, '2020-01-27', 580, 'células/μL', 630, 'copias/mL', 1, 'No_sabe'),
(100, 100, '2022-07-27', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(101, 101, '2021-10-20', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(102, 102, '2022-12-27', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(103, 103, '2022-04-14', 'Otro', '', 2, '2022-09-12', 262, 'células/μL', 846, 'copias/mL', 2, 'Si'),
(104, 104, '2023-07-13', 'Prueba rapida', '', 2, '2023-10-07', 892, 'células/μL', 788, 'copias/mL', 1, 'No_sabe'),
(105, 105, '2021-09-26', 'Western blot', '', 2, '2021-12-05', 940, 'células/μL', 871, 'copias/mL', 0, 'No'),
(106, 106, '2023-03-07', 'Otro', '', 2, '2021-12-24', 408, 'células/μL', 860, 'copias/mL', 1, 'No_sabe'),
(107, 107, '2022-06-14', 'Otro', '', 2, '2023-07-23', 282, 'células/μL', 757, 'copias/mL', 0, 'No'),
(108, 108, '2023-11-26', 'Western blot', '', 2, '2022-02-07', 972, 'células/μL', 954, 'copias/mL', 0, 'No'),
(109, 109, '2021-05-22', 'Elisa', '', 2, '2021-05-25', 934, 'células/μL', 901, 'copias/mL', 1, 'No_sabe'),
(110, 110, '2020-11-22', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(111, 111, '2021-07-02', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(112, 112, '2022-11-04', 'Otro', '', 2, '2023-01-04', 632, 'células/μL', 789, 'copias/mL', 2, 'Si'),
(113, 113, '2021-09-09', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(114, 114, '2023-07-28', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(115, 115, '2020-04-30', 'Prueba rapida', '', 2, '2023-06-12', 537, 'células/μL', 180, 'copias/mL', 0, 'No'),
(116, 116, '2020-12-21', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(117, 117, '2021-05-26', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(118, 118, '2021-01-12', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(119, 119, '2021-04-28', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(120, 120, '2021-08-13', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(121, 121, '2021-08-12', 'Elisa', '', 2, '2020-05-22', 903, 'células/μL', 285, 'copias/mL', 2, 'Si'),
(122, 122, '2023-07-31', 'Otro', '', 2, '2022-06-26', 391, 'células/μL', 506, 'copias/mL', 1, 'No_sabe'),
(123, 123, '2020-12-22', 'Prueba rapida', '', 2, '2020-10-24', 898, 'células/μL', 878, 'copias/mL', 2, 'Si'),
(124, 124, '2023-06-18', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(125, 125, '2021-10-04', 'Otro', '', 2, '2023-03-16', 960, 'células/μL', 268, 'copias/mL', 0, 'No'),
(126, 126, '2021-06-04', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(127, 127, '2020-08-14', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(128, 128, '2023-08-29', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(129, 129, '2022-10-22', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(130, 130, '2020-11-07', 'Otro', '', 2, '2021-08-19', 569, 'células/μL', 106, 'copias/mL', 0, 'No'),
(131, 131, '2022-05-09', 'Western blot', '', 2, '2022-06-12', 224, 'células/μL', 399, 'copias/mL', 2, 'Si'),
(132, 132, '2021-08-03', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(133, 133, '2022-03-27', 'Elisa', '', 2, '2022-09-09', 465, 'células/μL', 188, 'copias/mL', 0, 'No'),
(134, 134, '2020-11-20', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(135, 135, '2020-10-19', 'Western blot', '', 2, '2023-11-24', 598, 'células/μL', 123, 'copias/mL', 0, 'No'),
(136, 136, '2021-07-25', 'Western blot', '', 2, '2022-07-08', 495, 'células/μL', 845, 'copias/mL', 1, 'No_sabe'),
(137, 137, '2020-07-07', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(138, 138, '2021-01-09', 'Otro', '', 2, '2021-05-13', 799, 'células/μL', 546, 'copias/mL', 2, 'Si'),
(139, 139, '2022-11-22', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(140, 140, '2023-01-27', 'Elisa', '', 2, '2020-07-07', 367, 'células/μL', 314, 'copias/mL', 1, 'No_sabe'),
(141, 141, '2021-09-17', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(142, 142, '2020-01-07', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(143, 143, '2021-08-15', 'Western blot', '', 2, '2022-08-22', 766, 'células/μL', 307, 'copias/mL', 2, 'Si'),
(144, 144, '2020-03-26', 'Western blot', '', 2, '2023-02-17', 972, 'células/μL', 765, 'copias/mL', 1, 'No_sabe'),
(145, 145, '2022-10-15', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(146, 146, '2022-10-15', 'Otro', '', 2, '2020-03-10', 956, 'células/μL', 479, 'copias/mL', 2, 'Si'),
(147, 147, '2020-05-18', 'Western blot', '', 2, '2023-02-12', 414, 'células/μL', 703, 'copias/mL', 0, 'No'),
(148, 148, '2022-02-27', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(149, 149, '2021-10-29', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(150, 150, '2023-02-17', 'Elisa', '', 2, '2020-10-19', 666, 'células/μL', 101, 'copias/mL', 0, 'No'),
(151, 151, '2022-07-18', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(152, 152, '2022-02-11', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(153, 153, '2022-11-10', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(154, 154, '2021-03-28', 'Western blot', '', 2, '2021-12-06', 448, 'células/μL', 306, 'copias/mL', 1, 'No_sabe'),
(155, 155, '2023-03-23', 'Prueba rapida', '', 2, '2023-11-11', 475, 'células/μL', 432, 'copias/mL', 0, 'No'),
(156, 156, '2021-05-31', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(157, 157, '2020-03-01', 'Otro', '', 2, '2020-11-25', 457, 'células/μL', 287, 'copias/mL', 1, 'No_sabe'),
(158, 158, '2023-06-10', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(159, 159, '2021-12-04', 'Elisa', '', 2, '2022-09-01', 673, 'células/μL', 712, 'copias/mL', 1, 'No_sabe'),
(160, 160, '2023-05-16', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(161, 161, '2023-04-26', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(162, 162, '2021-12-26', 'Elisa', '', 2, '2020-08-13', 931, 'células/μL', 183, 'copias/mL', 2, 'Si'),
(163, 163, '2021-02-09', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(164, 164, '2022-06-20', 'Elisa', '', 2, '2022-07-01', 818, 'células/μL', 930, 'copias/mL', 1, 'No_sabe'),
(165, 165, '2020-11-22', 'Otro', '', 2, '2022-11-06', 861, 'células/μL', 874, 'copias/mL', 2, 'Si'),
(166, 166, '2021-09-29', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(167, 167, '2023-05-24', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(168, 168, '2020-05-16', 'Prueba rapida', '', 2, '2022-08-08', 392, 'células/μL', 528, 'copias/mL', 0, 'No'),
(169, 169, '2022-01-16', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(170, 170, '2020-12-14', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(171, 171, '2021-10-02', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(172, 172, '2022-08-17', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(173, 173, '2022-04-12', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(174, 174, '2023-10-13', 'Prueba rapida', '', 2, '2022-01-18', 998, 'células/μL', 356, 'copias/mL', 1, 'No_sabe'),
(175, 175, '2023-04-29', 'Elisa', '', 2, '2020-10-23', 599, 'células/μL', 999, 'copias/mL', 1, 'No_sabe'),
(176, 176, '2020-11-16', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(177, 177, '2022-10-24', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(178, 178, '2020-10-29', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(179, 179, '2021-02-27', 'Elisa', '', 2, '2022-10-11', 306, 'células/μL', 542, 'copias/mL', 0, 'No'),
(180, 180, '2021-04-18', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(181, 181, '2023-08-21', 'Prueba rapida', '', 2, '2021-08-25', 653, 'células/μL', 271, 'copias/mL', 1, 'No_sabe'),
(182, 182, '2020-04-07', 'Prueba rapida', '', 2, '2021-11-22', 496, 'células/μL', 572, 'copias/mL', 1, 'No_sabe'),
(183, 183, '2022-11-24', 'Prueba rapida', '', 2, '2021-08-06', 280, 'células/μL', 230, 'copias/mL', 1, 'No_sabe'),
(184, 184, '2023-06-30', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(185, 185, '2023-06-15', 'Elisa', '', 2, '2023-02-04', 951, 'células/μL', 942, 'copias/mL', 2, 'Si'),
(186, 186, '2020-02-28', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(187, 187, '2021-04-22', 'Prueba rapida', '', 2, '2020-03-20', 383, 'células/μL', 211, 'copias/mL', 0, 'No'),
(188, 188, '2021-04-16', 'Western blot', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(189, 189, '2020-11-28', 'Prueba rapida', '', 2, '2020-09-16', 362, 'células/μL', 239, 'copias/mL', 2, 'Si'),
(190, 190, '2020-01-26', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe'),
(191, 191, '2023-12-10', 'Western blot', '', 2, '2023-04-19', 972, 'células/μL', 288, 'copias/mL', 1, 'No_sabe'),
(192, 192, '2023-07-03', 'Elisa', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(193, 193, '2023-10-10', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(194, 194, '2023-11-05', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(195, 195, '2020-12-12', 'Prueba rapida', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 2, 'Si'),
(196, 196, '2020-10-16', 'Otro', '', 2, '2022-01-22', 861, 'células/μL', 207, 'copias/mL', 1, 'No_sabe'),
(197, 197, '2020-10-29', 'Elisa', '', 2, '2022-08-31', 869, 'células/μL', 592, 'copias/mL', 0, 'No'),
(198, 198, '2022-06-20', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 0, 'No'),
(199, 199, '2022-01-11', 'Otro', '', 2, '2021-11-02', 859, 'células/μL', 236, 'copias/mL', 2, 'Si'),
(200, 200, '2020-10-03', 'Otro', '', 0, NULL, 0, 'células/μL', 0, 'copias/mL', 1, 'No_sabe');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vih_modelo_prediccion_distrito`
--

CREATE TABLE `vih_modelo_prediccion_distrito` (
  `id_modelo` int NOT NULL,
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

--
-- Volcado de datos para la tabla `vih_modelo_prediccion_distrito`
--

INSERT INTO `vih_modelo_prediccion_distrito` (`id_modelo`, `nombre_modelo`, `version_modelo`, `algoritmo`, `parametros_xgboost`, `accuracy`, `mae_casos`, `rmse_casos`, `mape_porcentual`, `fecha_entrenamiento`, `fecha_actualizacion`, `modelo_activo`, `horizonte_prediccion_meses`, `descripcion`) VALUES
(1, 'Predictor VIH San Martín v1.0', '1.0.0', 'XGBoost', '{\"n_estimators\": 100, \"max_depth\": 6, \"learning_rate\": 0.1, \"subsample\": 0.8, \"colsample_bytree\": 0.8, \"random_state\": 42}', 0.85, 2.3, 3.1, 15.2, '2024-01-15 10:00:00', '2024-01-15 10:00:00', 1, 3, 'Modelo inicial para predicción de casos de VIH en distritos de San Martín usando XGBoost con características demográficas y epidemiológicas');

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

--
-- Volcado de datos para la tabla `vih_paciente`
--

INSERT INTO `vih_paciente` (`id_paciente`, `nombre_completo`, `numero_documento`, `tipo_documento`, `fecha_nacimiento`, `fecha_registro`, `activo`) VALUES
(1, 'Ana López Torres', '41735828', 'DNI', '1979-02-16', '2025-07-01 20:34:38', 1),
(2, 'Miguel Sánchez Torres', '26092506', 'DNI', '1957-01-14', '2025-07-01 20:34:38', 1),
(3, 'Luis Martínez González', '69355753', 'DNI', '1956-06-06', '2025-07-01 20:34:38', 1),
(4, 'Isabel Sánchez Fernández', '80730230', 'DNI', '1977-08-03', '2025-07-01 20:34:38', 1),
(5, 'María Torres López', '47162682', 'DNI', '1953-12-10', '2025-07-01 20:34:38', 1),
(6, 'Carlos Rodríguez Torres', '70948293', 'DNI', '1986-07-23', '2025-07-01 20:34:38', 1),
(7, 'Luis Torres Martínez', '81776058', 'DNI', '1979-05-16', '2025-07-01 20:34:39', 1),
(8, 'Laura Fernández Fernández', '95293056', 'DNI', '1960-01-18', '2025-07-01 20:34:39', 1),
(9, 'Luis Fernández Martínez', '84169469', 'DNI', '1995-02-25', '2025-07-01 20:34:39', 1),
(10, 'Laura García Fernández', '36714091', 'DNI', '1975-11-03', '2025-07-01 20:34:39', 1),
(11, 'Pedro Ramírez Pérez', '80957107', 'DNI', '1978-01-28', '2025-07-01 20:34:39', 1),
(12, 'Miguel García González', '61526284', 'DNI', '1964-08-17', '2025-07-01 20:34:39', 1),
(13, 'Juan Ramírez Rodríguez', '88779106', 'DNI', '1984-01-04', '2025-07-01 20:34:39', 1),
(14, 'Pedro Pérez González', '67409823', 'DNI', '1969-03-07', '2025-07-01 20:34:39', 1),
(15, 'Pedro Sánchez Torres', '57989883', 'DNI', '1955-01-10', '2025-07-01 20:34:40', 1),
(16, 'Isabel González Sánchez', '37102141', 'DNI', '1958-01-06', '2025-07-01 20:34:40', 1),
(17, 'Miguel Pérez Sánchez', '92672078', 'DNI', '1975-04-03', '2025-07-01 20:34:40', 1),
(18, 'Juan García Pérez', '10708883', 'DNI', '1978-05-21', '2025-07-01 20:34:40', 1),
(19, 'Miguel Torres Torres', '67995840', 'DNI', '1958-10-15', '2025-07-01 20:34:40', 1),
(20, 'Isabel Martínez Torres', '78112534', 'DNI', '1972-07-23', '2025-07-01 20:34:40', 1),
(21, 'Juan López Sánchez', '60874182', 'DNI', '1959-08-16', '2025-07-01 20:34:40', 1),
(22, 'María Pérez Martínez', '41677084', 'DNI', '1974-02-24', '2025-07-01 20:34:40', 1),
(23, 'Juan Rodríguez García', '94022320', 'DNI', '2000-08-17', '2025-07-01 20:34:40', 1),
(24, 'María Sánchez Torres', '63916510', 'DNI', '1953-03-20', '2025-07-01 20:34:40', 1),
(25, 'María Rodríguez Ramírez', '79213139', 'DNI', '1979-04-06', '2025-07-01 20:34:41', 1),
(26, 'Sofía Ramírez Sánchez', '82818615', 'DNI', '1965-11-13', '2025-07-01 20:34:41', 1),
(27, 'Carlos Ramírez Sánchez', '99727439', 'DNI', '1992-06-01', '2025-07-01 20:34:41', 1),
(28, 'Isabel López Sánchez', '66254278', 'DNI', '1974-05-04', '2025-07-01 20:34:41', 1),
(29, 'Sofía Pérez Torres', '52303097', 'DNI', '1984-11-04', '2025-07-01 20:34:41', 1),
(30, 'Carlos Fernández Rodríguez', '34401589', 'DNI', '1997-03-14', '2025-07-01 20:34:41', 1),
(31, 'Carlos Ramírez Fernández', '83984315', 'DNI', '1970-04-01', '2025-07-01 20:34:41', 1),
(32, 'Carlos Torres González', '24238605', 'DNI', '1963-08-15', '2025-07-01 20:34:41', 1),
(33, 'Juan Martínez Pérez', '74054351', 'DNI', '1976-09-15', '2025-07-01 20:34:41', 1),
(34, 'Ana López Sánchez', '94088261', 'DNI', '1962-04-11', '2025-07-01 20:34:41', 1),
(35, 'Pedro García Rodríguez', '64625898', 'DNI', '1967-11-03', '2025-07-01 20:34:42', 1),
(36, 'Sofía Torres Sánchez', '34793045', 'DNI', '1978-09-07', '2025-07-01 20:34:42', 1),
(37, 'Ana López Ramírez', '29908453', 'DNI', '1966-04-08', '2025-07-01 20:34:42', 1),
(38, 'Luis Martínez Rodríguez', '94598040', 'DNI', '1990-12-19', '2025-07-01 20:34:42', 1),
(39, 'Laura González Rodríguez', '88825410', 'DNI', '1956-01-20', '2025-07-01 20:34:42', 1),
(40, 'Juan Ramírez García', '25590272', 'DNI', '1979-04-13', '2025-07-01 20:34:42', 1),
(41, 'Miguel Ramírez Martínez', '31721232', 'DNI', '1958-02-15', '2025-07-01 20:34:42', 1),
(42, 'Carlos Sánchez Torres', '89654262', 'DNI', '1984-09-15', '2025-07-01 20:34:42', 1),
(43, 'Sofía Ramírez Fernández', '87597711', 'DNI', '1981-07-25', '2025-07-01 20:34:42', 1),
(44, 'Sofía González Sánchez', '36842268', 'DNI', '1960-12-22', '2025-07-01 20:34:42', 1),
(45, 'Ana González Rodríguez', '50140551', 'DNI', '1953-01-23', '2025-07-01 20:34:43', 1),
(46, 'Juan Rodríguez García', '57316337', 'DNI', '1970-12-24', '2025-07-01 20:34:43', 1),
(47, 'Ana Pérez Pérez', '60550061', 'DNI', '1950-03-03', '2025-07-01 20:34:43', 1),
(48, 'Sofía Martínez López', '46978268', 'DNI', '1955-05-25', '2025-07-01 20:34:43', 1),
(49, 'Isabel Fernández Torres', '73989960', 'DNI', '1957-09-25', '2025-07-01 20:34:43', 1),
(50, 'Sofía García Torres', '11715797', 'DNI', '1997-09-10', '2025-07-01 20:34:43', 1),
(51, 'Miguel García Martínez', '59887379', 'DNI', '1956-07-28', '2025-07-01 20:34:43', 1),
(52, 'Isabel Ramírez López', '21694301', 'DNI', '1972-05-06', '2025-07-01 20:34:43', 1),
(53, 'María Pérez Rodríguez', '74208410', 'DNI', '1965-09-03', '2025-07-01 20:34:43', 1),
(54, 'Miguel Fernández Torres', '73360582', 'DNI', '1953-11-05', '2025-07-01 20:34:44', 1),
(55, 'Isabel Torres Fernández', '44314956', 'DNI', '1995-08-19', '2025-07-01 20:34:44', 1),
(56, 'Sofía Ramírez Ramírez', '21030673', 'DNI', '1958-06-23', '2025-07-01 20:34:44', 1),
(57, 'Juan Fernández Rodríguez', '06071898', 'DNI', '1974-09-08', '2025-07-01 20:34:44', 1),
(58, 'Pedro Fernández Pérez', '71232397', 'DNI', '1988-09-19', '2025-07-01 20:34:44', 1),
(59, 'Carlos Pérez Fernández', '03460260', 'DNI', '2000-06-25', '2025-07-01 20:34:44', 1),
(60, 'Juan López Martínez', '87816765', 'DNI', '1957-06-15', '2025-07-01 20:34:44', 1),
(61, 'Pedro Ramírez López', '56605983', 'DNI', '1957-08-11', '2025-07-01 20:34:44', 1),
(62, 'Laura Torres Sánchez', '98941676', 'DNI', '1959-01-02', '2025-07-01 20:34:44', 1),
(63, 'Luis García García', '51763715', 'DNI', '1952-05-19', '2025-07-01 20:34:44', 1),
(64, 'María González Fernández', '04101056', 'DNI', '1996-09-18', '2025-07-01 20:34:44', 1),
(65, 'María Sánchez Sánchez', '00595853', 'DNI', '1988-05-25', '2025-07-01 20:34:45', 1),
(66, 'Laura Martínez Ramírez', '49064327', 'DNI', '1981-10-01', '2025-07-01 20:34:45', 1),
(67, 'Juan González González', '82694986', 'DNI', '1964-01-14', '2025-07-01 20:34:45', 1),
(68, 'María Martínez Fernández', '71226301', 'DNI', '1990-04-14', '2025-07-01 20:34:45', 1),
(69, 'Luis González López', '66134579', 'DNI', '1987-10-25', '2025-07-01 20:34:45', 1),
(70, 'Carlos Pérez López', '46773387', 'DNI', '1965-02-25', '2025-07-01 20:34:45', 1),
(71, 'Laura García Ramírez', '68572965', 'DNI', '1951-09-19', '2025-07-01 20:34:45', 1),
(72, 'Ana González Martínez', '13800935', 'DNI', '1978-01-17', '2025-07-01 20:34:45', 1),
(73, 'Ana Martínez Torres', '13072608', 'DNI', '1956-04-23', '2025-07-01 20:34:45', 1),
(74, 'Miguel Torres Fernández', '98703618', 'DNI', '1964-10-07', '2025-07-01 20:34:45', 1),
(75, 'María Sánchez González', '69420785', 'DNI', '1974-01-27', '2025-07-01 20:34:46', 1),
(76, 'Laura López Martínez', '55902754', 'DNI', '1975-11-08', '2025-07-01 20:34:46', 1),
(77, 'Laura Torres Fernández', '56685544', 'DNI', '1960-02-20', '2025-07-01 20:34:46', 1),
(78, 'Sofía Ramírez Fernández', '20028619', 'DNI', '1978-04-12', '2025-07-01 20:34:46', 1),
(79, 'Laura García Sánchez', '82585854', 'DNI', '1972-06-07', '2025-07-01 20:34:46', 1),
(80, 'Pedro Fernández López', '17172968', 'DNI', '1962-09-24', '2025-07-01 20:34:46', 1),
(81, 'Laura Rodríguez Sánchez', '77916763', 'DNI', '1991-02-19', '2025-07-01 20:34:46', 1),
(82, 'Pedro López Ramírez', '40037822', 'DNI', '1954-08-24', '2025-07-01 20:34:46', 1),
(83, 'Luis Sánchez López', '71086035', 'DNI', '1993-07-05', '2025-07-01 20:34:46', 1),
(84, 'Carlos Pérez Torres', '23694797', 'DNI', '1999-12-14', '2025-07-01 20:34:46', 1),
(85, 'Laura González García', '07628533', 'DNI', '1974-03-08', '2025-07-01 20:34:46', 1),
(86, 'Laura González Pérez', '41293051', 'DNI', '1951-05-02', '2025-07-01 20:34:46', 1),
(87, 'Juan González González', '53478111', 'DNI', '1976-08-20', '2025-07-01 20:34:46', 1),
(88, 'Carlos Martínez Sánchez', '04390791', 'DNI', '1976-08-26', '2025-07-01 20:34:46', 1),
(89, 'Juan Fernández Martínez', '03548659', 'DNI', '1993-12-07', '2025-07-01 20:34:46', 1),
(90, 'Miguel Sánchez García', '89784519', 'DNI', '1995-12-24', '2025-07-01 20:34:46', 1),
(91, 'Ana Rodríguez López', '49967800', 'DNI', '1981-05-25', '2025-07-01 20:34:46', 1),
(92, 'Luis Ramírez Pérez', '99884785', 'DNI', '1979-11-27', '2025-07-01 20:34:46', 1),
(93, 'Sofía Martínez García', '84370339', 'DNI', '1998-05-25', '2025-07-01 20:34:47', 1),
(94, 'Carlos Pérez Fernández', '06230063', 'DNI', '1953-12-07', '2025-07-01 20:34:47', 1),
(95, 'Luis Fernández García', '33986642', 'DNI', '1971-02-02', '2025-07-01 20:34:47', 1),
(96, 'Pedro Martínez Fernández', '32361871', 'DNI', '1989-01-15', '2025-07-01 20:34:47', 1),
(97, 'Miguel Fernández Fernández', '20501187', 'DNI', '1954-01-08', '2025-07-01 20:34:47', 1),
(98, 'Juan García Torres', '30398821', 'DNI', '1958-09-04', '2025-07-01 20:34:47', 1),
(99, 'Juan Fernández Torres', '92537928', 'DNI', '1956-12-14', '2025-07-01 20:34:47', 1),
(100, 'Pedro Fernández Sánchez', '95583789', 'DNI', '1977-12-07', '2025-07-01 20:34:47', 1),
(101, 'Luis López Sánchez', '65129629', 'DNI', '1993-03-16', '2025-07-01 20:34:47', 1),
(102, 'Luis Rodríguez González', '05369557', 'DNI', '1993-07-16', '2025-07-01 20:34:47', 1),
(103, 'María Sánchez Fernández', '88414184', 'DNI', '1977-05-04', '2025-07-01 20:34:48', 1),
(104, 'Ana Torres Sánchez', '11786508', 'DNI', '1996-03-07', '2025-07-01 20:34:48', 1),
(105, 'Luis López Torres', '88714414', 'DNI', '1992-07-04', '2025-07-01 20:34:48', 1),
(106, 'Carlos Martínez Fernández', '03497830', 'DNI', '2000-08-26', '2025-07-01 20:34:48', 1),
(107, 'María Sánchez Pérez', '97964389', 'DNI', '1952-01-24', '2025-07-01 20:34:48', 1),
(108, 'Pedro Sánchez Torres', '43831889', 'DNI', '1999-10-25', '2025-07-01 20:34:48', 1),
(109, 'Pedro Rodríguez Torres', '54808650', 'DNI', '1975-06-07', '2025-07-01 20:34:48', 1),
(110, 'Juan Ramírez Fernández', '48631727', 'DNI', '1974-12-08', '2025-07-01 20:34:48', 1),
(111, 'Carlos Martínez Fernández', '73843578', 'DNI', '1991-08-10', '2025-07-01 20:34:48', 1),
(112, 'Sofía Martínez López', '52134990', 'DNI', '1965-12-18', '2025-07-01 20:34:49', 1),
(113, 'Sofía Ramírez Ramírez', '34603922', 'DNI', '1982-06-14', '2025-07-01 20:34:49', 1),
(114, 'Pedro Fernández Torres', '27515441', 'DNI', '1963-08-06', '2025-07-01 20:34:49', 1),
(115, 'Isabel González Torres', '70030966', 'DNI', '1975-09-22', '2025-07-01 20:34:49', 1),
(116, 'Laura Fernández Ramírez', '87466777', 'DNI', '1952-04-07', '2025-07-01 20:34:49', 1),
(117, 'Carlos Fernández Fernández', '04085853', 'DNI', '1955-01-03', '2025-07-01 20:34:49', 1),
(118, 'Laura Rodríguez López', '74773220', 'DNI', '1991-03-14', '2025-07-01 20:34:49', 1),
(119, 'Miguel Sánchez Rodríguez', '95533724', 'DNI', '1990-06-02', '2025-07-01 20:34:49', 1),
(120, 'María González González', '45465838', 'DNI', '1980-08-19', '2025-07-01 20:34:50', 1),
(121, 'Luis González Ramírez', '19732902', 'DNI', '1953-10-14', '2025-07-01 20:34:50', 1),
(122, 'Isabel Martínez Martínez', '14382315', 'DNI', '1998-10-08', '2025-07-01 20:34:50', 1),
(123, 'Laura Rodríguez González', '29171357', 'DNI', '1998-11-23', '2025-07-01 20:34:50', 1),
(124, 'María Torres López', '90116621', 'DNI', '1997-12-18', '2025-07-01 20:34:50', 1),
(125, 'María García Pérez', '88084881', 'DNI', '1956-12-19', '2025-07-01 20:34:50', 1),
(126, 'Laura López Martínez', '78320173', 'DNI', '1967-09-01', '2025-07-01 20:34:50', 1),
(127, 'Laura Sánchez Fernández', '23770363', 'DNI', '1965-11-12', '2025-07-01 20:34:50', 1),
(128, 'Isabel Torres García', '28248427', 'DNI', '1992-02-23', '2025-07-01 20:34:50', 1),
(129, 'Ana Martínez Rodríguez', '89207340', 'DNI', '1962-03-03', '2025-07-01 20:34:50', 1),
(130, 'Carlos García Martínez', '24529165', 'DNI', '1981-08-22', '2025-07-01 20:34:51', 1),
(131, 'Carlos Fernández Rodríguez', '67001232', 'DNI', '1958-07-26', '2025-07-01 20:34:51', 1),
(132, 'Juan García Torres', '54516609', 'DNI', '1982-01-27', '2025-07-01 20:34:51', 1),
(133, 'Carlos Martínez López', '53896078', 'DNI', '1967-03-03', '2025-07-01 20:34:51', 1),
(134, 'Isabel Ramírez García', '00905835', 'DNI', '1995-01-15', '2025-07-01 20:34:51', 1),
(135, 'Miguel García Torres', '02209866', 'DNI', '1957-03-03', '2025-07-01 20:34:51', 1),
(136, 'Pedro Martínez Pérez', '89718649', 'DNI', '1992-01-08', '2025-07-01 20:34:51', 1),
(137, 'Miguel Rodríguez García', '79926743', 'DNI', '1990-06-06', '2025-07-01 20:34:51', 1),
(138, 'Ana Torres Torres', '28811275', 'DNI', '1974-05-22', '2025-07-01 20:34:51', 1),
(139, 'Isabel Sánchez Martínez', '46072200', 'DNI', '1983-07-27', '2025-07-01 20:34:51', 1),
(140, 'Sofía Martínez García', '82667076', 'DNI', '1964-08-07', '2025-07-01 20:34:52', 1),
(141, 'Juan Ramírez Ramírez', '82544047', 'DNI', '1958-04-10', '2025-07-01 20:34:52', 1),
(142, 'Miguel González Martínez', '49414061', 'DNI', '1991-10-12', '2025-07-01 20:34:52', 1),
(143, 'Carlos Torres Pérez', '94302631', 'DNI', '1990-01-06', '2025-07-01 20:34:52', 1),
(144, 'Isabel Ramírez Sánchez', '53700165', 'DNI', '1954-02-14', '2025-07-01 20:34:52', 1),
(145, 'Ana González García', '40788989', 'DNI', '1984-02-12', '2025-07-01 20:34:52', 1),
(146, 'Ana Rodríguez González', '80075958', 'DNI', '1959-07-13', '2025-07-01 20:34:52', 1),
(147, 'Sofía Martínez Sánchez', '50710808', 'DNI', '1994-12-26', '2025-07-01 20:34:52', 1),
(148, 'Ana Sánchez López', '59514247', 'DNI', '1975-09-28', '2025-07-01 20:34:52', 1),
(149, 'Juan González Rodríguez', '90929606', 'DNI', '1975-09-21', '2025-07-01 20:34:53', 1),
(150, 'Ana Rodríguez González', '83467992', 'DNI', '1957-10-28', '2025-07-01 20:34:53', 1),
(151, 'Ana Fernández Torres', '28925471', 'DNI', '1959-10-01', '2025-07-01 20:34:53', 1),
(152, 'Juan Ramírez Martínez', '68189556', 'DNI', '1980-03-09', '2025-07-01 20:34:53', 1),
(153, 'Miguel Martínez Pérez', '18666644', 'DNI', '1986-08-26', '2025-07-01 20:34:53', 1),
(154, 'Sofía Sánchez Sánchez', '79478030', 'DNI', '1982-12-01', '2025-07-01 20:34:53', 1),
(155, 'Sofía Sánchez Ramírez', '01560225', 'DNI', '1993-09-02', '2025-07-01 20:34:53', 1),
(156, 'Juan Pérez López', '92049061', 'DNI', '1992-03-07', '2025-07-01 20:34:53', 1),
(157, 'Luis Torres González', '27715585', 'DNI', '1953-02-11', '2025-07-01 20:34:53', 1),
(158, 'Luis García López', '36061660', 'DNI', '1988-03-21', '2025-07-01 20:34:53', 1),
(159, 'Ana Fernández Sánchez', '09715112', 'DNI', '1955-02-20', '2025-07-01 20:34:54', 1),
(160, 'Luis Rodríguez García', '00114354', 'DNI', '1956-08-13', '2025-07-01 20:34:54', 1),
(161, 'Sofía López González', '96356148', 'DNI', '1986-03-01', '2025-07-01 20:34:54', 1),
(162, 'Laura García Sánchez', '67840931', 'DNI', '1959-06-02', '2025-07-01 20:34:54', 1),
(163, 'Pedro Ramírez Ramírez', '60074924', 'DNI', '1964-04-03', '2025-07-01 20:34:54', 1),
(164, 'Laura Pérez Pérez', '17538917', 'DNI', '1989-07-17', '2025-07-01 20:34:54', 1),
(165, 'Juan Sánchez Martínez', '71955301', 'DNI', '1965-02-05', '2025-07-01 20:34:54', 1),
(166, 'Juan Pérez Martínez', '90996149', 'DNI', '1966-02-28', '2025-07-01 20:34:54', 1),
(167, 'Pedro Martínez García', '19080522', 'DNI', '1952-02-23', '2025-07-01 20:34:54', 1),
(168, 'María Fernández Torres', '69917525', 'DNI', '1992-10-18', '2025-07-01 20:34:54', 1),
(169, 'Carlos Torres Fernández', '54056679', 'DNI', '1961-02-04', '2025-07-01 20:34:55', 1),
(170, 'Carlos Pérez Fernández', '30088093', 'DNI', '1992-08-09', '2025-07-01 20:34:55', 1),
(171, 'Laura López Torres', '71766114', 'DNI', '1988-09-16', '2025-07-01 20:34:55', 1),
(172, 'Sofía Ramírez García', '88062585', 'DNI', '1998-11-11', '2025-07-01 20:34:55', 1),
(173, 'María Fernández Sánchez', '78150672', 'DNI', '1950-04-06', '2025-07-01 20:34:55', 1),
(174, 'María Sánchez López', '24495000', 'DNI', '1954-06-01', '2025-07-01 20:34:55', 1),
(175, 'Pedro Rodríguez López', '92290788', 'DNI', '1985-07-06', '2025-07-01 20:34:55', 1),
(176, 'Miguel Ramírez Fernández', '76712626', 'DNI', '1977-02-26', '2025-07-01 20:34:55', 1),
(177, 'Sofía Torres Torres', '27911774', 'DNI', '1979-05-13', '2025-07-01 20:34:55', 1),
(178, 'Pedro Torres Ramírez', '52486247', 'DNI', '1985-02-07', '2025-07-01 20:34:56', 1),
(179, 'María García Rodríguez', '33980889', 'DNI', '1989-07-05', '2025-07-01 20:34:56', 1),
(180, 'Pedro Fernández Fernández', '65814995', 'DNI', '1975-06-21', '2025-07-01 20:34:56', 1),
(181, 'Pedro Rodríguez López', '77628089', 'DNI', '1954-11-23', '2025-07-01 20:34:56', 1),
(182, 'Isabel Torres García', '29810142', 'DNI', '1956-08-28', '2025-07-01 20:34:56', 1),
(183, 'Luis González Fernández', '05706397', 'DNI', '1999-07-21', '2025-07-01 20:34:56', 1),
(184, 'Carlos Ramírez González', '75244536', 'DNI', '1987-02-15', '2025-07-01 20:34:56', 1),
(185, 'Isabel Pérez Pérez', '65290269', 'DNI', '1959-01-03', '2025-07-01 20:34:56', 1),
(186, 'Isabel García Rodríguez', '34468774', 'DNI', '1985-09-07', '2025-07-01 20:34:56', 1),
(187, 'Laura López Pérez', '03025435', 'DNI', '1987-12-23', '2025-07-01 20:34:56', 1),
(188, 'Laura Pérez Fernández', '22426543', 'DNI', '1977-01-28', '2025-07-01 20:34:56', 1),
(189, 'María Ramírez Rodríguez', '24909207', 'DNI', '1965-09-07', '2025-07-01 20:34:56', 1),
(190, 'Carlos González Sánchez', '07374710', 'DNI', '1971-05-26', '2025-07-01 20:34:56', 1),
(191, 'Miguel Martínez López', '66158019', 'DNI', '1979-02-04', '2025-07-01 20:34:57', 1),
(192, 'Carlos Rodríguez Pérez', '44974040', 'DNI', '1967-04-21', '2025-07-01 20:34:57', 1),
(193, 'Laura García Sánchez', '61231660', 'DNI', '1953-09-18', '2025-07-01 20:34:57', 1),
(194, 'Luis González López', '43209413', 'DNI', '1980-07-16', '2025-07-01 20:34:57', 1),
(195, 'Luis Rodríguez Martínez', '10086153', 'DNI', '1971-12-23', '2025-07-01 20:34:57', 1),
(196, 'Pedro Sánchez Pérez', '71632075', 'DNI', '1964-11-16', '2025-07-01 20:34:57', 1),
(197, 'Isabel García Martínez', '75368485', 'DNI', '1986-08-22', '2025-07-01 20:34:57', 1),
(198, 'Sofía Sánchez González', '40106548', 'DNI', '1959-03-11', '2025-07-01 20:34:57', 1),
(199, 'Ana Torres Torres', '92665455', 'DNI', '1998-04-25', '2025-07-01 20:34:57', 1),
(200, 'Luis Rodríguez Martínez', '77075785', 'DNI', '1950-05-10', '2025-07-01 20:34:57', 1);

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
-- Estructura de tabla para la tabla `vih_prediccion_casos_distrito`
--

CREATE TABLE `vih_prediccion_casos_distrito` (
  `id_prediccion` int NOT NULL,
  `id_modelo` int NOT NULL,
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
-- Volcado de datos para la tabla `vih_riesgo_transmision`
--

INSERT INTO `vih_riesgo_transmision` (`id_riesgo`, `id_cuestionario`, `tiene_pareja_activa`, `informa_estado_vih`, `uso_preservativo_actual`, `pareja_prueba_vih`) VALUES
(1, 1, 0, 'A_veces', 'Nunca', 'No_sabe'),
(2, 2, 0, 'A_veces', 'Nunca', 'No_sabe'),
(3, 3, 0, 'Siempre', 'Siempre', 'No_sabe'),
(4, 4, 0, 'A_veces', 'Nunca', 'No_sabe'),
(5, 5, 2, 'A_veces', 'A_veces', 'No_sabe'),
(6, 6, 0, 'Siempre', 'Siempre', 'No_sabe'),
(7, 7, 0, 'A_veces', 'Siempre', 'No_sabe'),
(8, 8, 2, 'Siempre', 'Nunca', 'No_sabe'),
(9, 9, 0, 'Siempre', 'Siempre', 'No_sabe'),
(10, 10, 2, 'A_veces', 'Nunca', 'No_sabe'),
(11, 11, 0, 'A_veces', 'Nunca', 'No_sabe'),
(12, 12, 0, 'Nunca', 'Nunca', 'No_sabe'),
(13, 13, 2, 'Siempre', 'Nunca', 'No_sabe'),
(14, 14, 2, 'Nunca', 'Nunca', 'No_sabe'),
(15, 15, 0, 'A_veces', 'Siempre', 'No_sabe'),
(16, 16, 0, 'Nunca', 'A_veces', 'No_sabe'),
(17, 17, 0, 'Siempre', 'A_veces', 'No_sabe'),
(18, 18, 2, 'Nunca', 'Siempre', 'No_sabe'),
(19, 19, 0, 'Siempre', 'Siempre', 'No_sabe'),
(20, 20, 2, 'A_veces', 'A_veces', 'No_sabe'),
(21, 21, 2, 'A_veces', 'A_veces', 'No_sabe'),
(22, 22, 0, 'Siempre', 'A_veces', 'No_sabe'),
(23, 23, 2, 'A_veces', 'A_veces', 'No_sabe'),
(24, 24, 0, 'A_veces', 'A_veces', 'No_sabe'),
(25, 25, 0, 'A_veces', 'Nunca', 'No_sabe'),
(26, 26, 0, 'A_veces', 'Siempre', 'No_sabe'),
(27, 27, 0, 'Siempre', 'Nunca', 'No_sabe'),
(28, 28, 0, 'Nunca', 'A_veces', 'No_sabe'),
(29, 29, 2, 'Nunca', 'A_veces', 'No_sabe'),
(30, 30, 2, 'A_veces', 'A_veces', 'No_sabe'),
(31, 31, 0, 'Nunca', 'Nunca', 'No_sabe'),
(32, 32, 0, 'Nunca', 'Nunca', 'No_sabe'),
(33, 33, 2, 'A_veces', 'A_veces', 'No_sabe'),
(34, 34, 2, 'A_veces', 'Nunca', 'No_sabe'),
(35, 35, 2, 'Nunca', 'Nunca', 'No_sabe'),
(36, 36, 2, 'Siempre', 'A_veces', 'No_sabe'),
(37, 37, 0, 'A_veces', 'Nunca', 'No_sabe'),
(38, 38, 0, 'Siempre', 'Siempre', 'No_sabe'),
(39, 39, 2, 'Nunca', 'Siempre', 'No_sabe'),
(40, 40, 0, 'A_veces', 'Siempre', 'No_sabe'),
(41, 41, 2, 'Siempre', 'Siempre', 'No_sabe'),
(42, 42, 0, 'A_veces', 'A_veces', 'No_sabe'),
(43, 43, 2, 'Nunca', 'A_veces', 'No_sabe'),
(44, 44, 0, 'Siempre', 'A_veces', 'No_sabe'),
(45, 45, 2, 'Nunca', 'Siempre', 'No_sabe'),
(46, 46, 2, 'Nunca', 'Siempre', 'No_sabe'),
(47, 47, 0, 'A_veces', 'Nunca', 'No_sabe'),
(48, 48, 2, 'Siempre', 'Nunca', 'No_sabe'),
(49, 49, 0, 'Nunca', 'Siempre', 'No_sabe'),
(50, 50, 0, 'Nunca', 'Siempre', 'No_sabe'),
(51, 51, 2, 'Siempre', 'Siempre', 'No_sabe'),
(52, 52, 0, 'Nunca', 'Siempre', 'No_sabe'),
(53, 53, 0, 'Nunca', 'Nunca', 'No_sabe'),
(54, 54, 0, 'Siempre', 'Siempre', 'No_sabe'),
(55, 55, 0, 'Siempre', 'Nunca', 'No_sabe'),
(56, 56, 0, 'Siempre', 'Siempre', 'No_sabe'),
(57, 57, 2, 'Siempre', 'Siempre', 'No_sabe'),
(58, 58, 0, 'A_veces', 'Siempre', 'No_sabe'),
(59, 59, 0, 'Siempre', 'Nunca', 'No_sabe'),
(60, 60, 0, 'A_veces', 'Nunca', 'No_sabe'),
(61, 61, 0, 'A_veces', 'A_veces', 'No_sabe'),
(62, 62, 0, 'A_veces', 'Siempre', 'No_sabe'),
(63, 63, 2, 'Nunca', 'A_veces', 'No_sabe'),
(64, 64, 0, 'A_veces', 'A_veces', 'No_sabe'),
(65, 65, 2, 'A_veces', 'Nunca', 'No_sabe'),
(66, 66, 2, 'Nunca', 'Nunca', 'No_sabe'),
(67, 67, 2, 'Nunca', 'A_veces', 'No_sabe'),
(68, 68, 2, 'Nunca', 'Siempre', 'No_sabe'),
(69, 69, 0, 'Siempre', 'Nunca', 'No_sabe'),
(70, 70, 2, 'Nunca', 'Siempre', 'No_sabe'),
(71, 71, 2, 'Nunca', 'Siempre', 'No_sabe'),
(72, 72, 0, 'A_veces', 'A_veces', 'No_sabe'),
(73, 73, 0, 'Nunca', 'A_veces', 'No_sabe'),
(74, 74, 0, 'Siempre', 'A_veces', 'No_sabe'),
(75, 75, 2, 'Nunca', 'A_veces', 'No_sabe'),
(76, 76, 0, 'Siempre', 'Nunca', 'No_sabe'),
(77, 77, 0, 'Nunca', 'Nunca', 'No_sabe'),
(78, 78, 2, 'Nunca', 'A_veces', 'No_sabe'),
(79, 79, 0, 'Nunca', 'Nunca', 'No_sabe'),
(80, 80, 0, 'Nunca', 'A_veces', 'No_sabe'),
(81, 81, 0, 'Siempre', 'Siempre', 'No_sabe'),
(82, 82, 0, 'Siempre', 'Siempre', 'No_sabe'),
(83, 83, 2, 'A_veces', 'Siempre', 'No_sabe'),
(84, 84, 0, 'Siempre', 'A_veces', 'No_sabe'),
(85, 85, 0, 'Nunca', 'Siempre', 'No_sabe'),
(86, 86, 2, 'A_veces', 'Nunca', 'No_sabe'),
(87, 87, 0, 'A_veces', 'Siempre', 'No_sabe'),
(88, 88, 2, 'A_veces', 'Siempre', 'No_sabe'),
(89, 89, 0, 'Nunca', 'Siempre', 'No_sabe'),
(90, 90, 2, 'Siempre', 'Nunca', 'No_sabe'),
(91, 91, 2, 'Nunca', 'A_veces', 'No_sabe'),
(92, 92, 2, 'A_veces', 'Nunca', 'No_sabe'),
(93, 93, 2, 'Nunca', 'A_veces', 'No_sabe'),
(94, 94, 0, 'Nunca', 'A_veces', 'No_sabe'),
(95, 95, 2, 'Siempre', 'Siempre', 'No_sabe'),
(96, 96, 0, 'Siempre', 'A_veces', 'No_sabe'),
(97, 97, 2, 'A_veces', 'Nunca', 'No_sabe'),
(98, 98, 2, 'Nunca', 'Nunca', 'No_sabe'),
(99, 99, 2, 'Nunca', 'A_veces', 'No_sabe'),
(100, 100, 0, 'Siempre', 'Siempre', 'No_sabe'),
(101, 101, 2, 'Nunca', 'Siempre', 'No_sabe'),
(102, 102, 0, 'Nunca', 'Nunca', 'No_sabe'),
(103, 103, 0, 'Nunca', 'Siempre', 'No_sabe'),
(104, 104, 0, 'Siempre', 'A_veces', 'No_sabe'),
(105, 105, 0, 'A_veces', 'A_veces', 'No_sabe'),
(106, 106, 0, 'A_veces', 'Nunca', 'No_sabe'),
(107, 107, 0, 'Nunca', 'A_veces', 'No_sabe'),
(108, 108, 0, 'A_veces', 'Nunca', 'No_sabe'),
(109, 109, 0, 'Siempre', 'A_veces', 'No_sabe'),
(110, 110, 0, 'Siempre', 'Nunca', 'No_sabe'),
(111, 111, 2, 'A_veces', 'Siempre', 'No_sabe'),
(112, 112, 2, 'A_veces', 'A_veces', 'No_sabe'),
(113, 113, 2, 'Nunca', 'A_veces', 'No_sabe'),
(114, 114, 2, 'A_veces', 'Nunca', 'No_sabe'),
(115, 115, 2, 'Nunca', 'Nunca', 'No_sabe'),
(116, 116, 0, 'Nunca', 'A_veces', 'No_sabe'),
(117, 117, 0, 'Siempre', 'Nunca', 'No_sabe'),
(118, 118, 0, 'Siempre', 'A_veces', 'No_sabe'),
(119, 119, 0, 'Siempre', 'Siempre', 'No_sabe'),
(120, 120, 0, 'Siempre', 'Nunca', 'No_sabe'),
(121, 121, 0, 'A_veces', 'A_veces', 'No_sabe'),
(122, 122, 0, 'Siempre', 'Siempre', 'No_sabe'),
(123, 123, 2, 'A_veces', 'Siempre', 'No_sabe'),
(124, 124, 2, 'Siempre', 'A_veces', 'No_sabe'),
(125, 125, 2, 'A_veces', 'Nunca', 'No_sabe'),
(126, 126, 2, 'Nunca', 'A_veces', 'No_sabe'),
(127, 127, 0, 'A_veces', 'Siempre', 'No_sabe'),
(128, 128, 0, 'A_veces', 'A_veces', 'No_sabe'),
(129, 129, 0, 'Siempre', 'Nunca', 'No_sabe'),
(130, 130, 2, 'A_veces', 'Siempre', 'No_sabe'),
(131, 131, 0, 'Nunca', 'A_veces', 'No_sabe'),
(132, 132, 0, 'Nunca', 'Nunca', 'No_sabe'),
(133, 133, 0, 'Siempre', 'Siempre', 'No_sabe'),
(134, 134, 2, 'Nunca', 'Nunca', 'No_sabe'),
(135, 135, 0, 'A_veces', 'Siempre', 'No_sabe'),
(136, 136, 2, 'Nunca', 'A_veces', 'No_sabe'),
(137, 137, 2, 'Siempre', 'Nunca', 'No_sabe'),
(138, 138, 2, 'A_veces', 'Siempre', 'No_sabe'),
(139, 139, 2, 'Siempre', 'Nunca', 'No_sabe'),
(140, 140, 0, 'A_veces', 'Nunca', 'No_sabe'),
(141, 141, 2, 'Nunca', 'A_veces', 'No_sabe'),
(142, 142, 2, 'Siempre', 'Nunca', 'No_sabe'),
(143, 143, 0, 'Siempre', 'Siempre', 'No_sabe'),
(144, 144, 0, 'A_veces', 'Siempre', 'No_sabe'),
(145, 145, 2, 'Siempre', 'Siempre', 'No_sabe'),
(146, 146, 0, 'A_veces', 'Siempre', 'No_sabe'),
(147, 147, 2, 'A_veces', 'A_veces', 'No_sabe'),
(148, 148, 2, 'A_veces', 'Nunca', 'No_sabe'),
(149, 149, 2, 'A_veces', 'A_veces', 'No_sabe'),
(150, 150, 2, 'Nunca', 'Nunca', 'No_sabe'),
(151, 151, 0, 'A_veces', 'Nunca', 'No_sabe'),
(152, 152, 2, 'Siempre', 'Nunca', 'No_sabe'),
(153, 153, 0, 'Nunca', 'A_veces', 'No_sabe'),
(154, 154, 0, 'Siempre', 'Nunca', 'No_sabe'),
(155, 155, 0, 'Nunca', 'A_veces', 'No_sabe'),
(156, 156, 0, 'A_veces', 'Siempre', 'No_sabe'),
(157, 157, 2, 'Nunca', 'Siempre', 'No_sabe'),
(158, 158, 0, 'Nunca', 'Nunca', 'No_sabe'),
(159, 159, 2, 'Siempre', 'A_veces', 'No_sabe'),
(160, 160, 0, 'Siempre', 'Siempre', 'No_sabe'),
(161, 161, 0, 'A_veces', 'A_veces', 'No_sabe'),
(162, 162, 2, 'Nunca', 'A_veces', 'No_sabe'),
(163, 163, 2, 'Nunca', 'Nunca', 'No_sabe'),
(164, 164, 2, 'Nunca', 'Siempre', 'No_sabe'),
(165, 165, 0, 'A_veces', 'Nunca', 'No_sabe'),
(166, 166, 0, 'A_veces', 'Nunca', 'No_sabe'),
(167, 167, 2, 'A_veces', 'Siempre', 'No_sabe'),
(168, 168, 2, 'A_veces', 'Siempre', 'No_sabe'),
(169, 169, 2, 'A_veces', 'A_veces', 'No_sabe'),
(170, 170, 2, 'Siempre', 'Siempre', 'No_sabe'),
(171, 171, 0, 'Nunca', 'A_veces', 'No_sabe'),
(172, 172, 2, 'Nunca', 'A_veces', 'No_sabe'),
(173, 173, 2, 'Nunca', 'A_veces', 'No_sabe'),
(174, 174, 2, 'Nunca', 'Siempre', 'No_sabe'),
(175, 175, 2, 'Nunca', 'Nunca', 'No_sabe'),
(176, 176, 0, 'Nunca', 'A_veces', 'No_sabe'),
(177, 177, 2, 'Nunca', 'Nunca', 'No_sabe'),
(178, 178, 0, 'Nunca', 'Nunca', 'No_sabe'),
(179, 179, 2, 'Siempre', 'Siempre', 'No_sabe'),
(180, 180, 2, 'Nunca', 'Nunca', 'No_sabe'),
(181, 181, 0, 'Siempre', 'Nunca', 'No_sabe'),
(182, 182, 2, 'A_veces', 'Siempre', 'No_sabe'),
(183, 183, 0, 'Nunca', 'A_veces', 'No_sabe'),
(184, 184, 0, 'A_veces', 'Nunca', 'No_sabe'),
(185, 185, 2, 'A_veces', 'Siempre', 'No_sabe'),
(186, 186, 0, 'A_veces', 'Nunca', 'No_sabe'),
(187, 187, 0, 'Siempre', 'Nunca', 'No_sabe'),
(188, 188, 0, 'A_veces', 'A_veces', 'No_sabe'),
(189, 189, 0, 'A_veces', 'Nunca', 'No_sabe'),
(190, 190, 0, 'A_veces', 'Siempre', 'No_sabe'),
(191, 191, 0, 'Nunca', 'Nunca', 'No_sabe'),
(192, 192, 0, 'Nunca', 'A_veces', 'No_sabe'),
(193, 193, 0, 'Siempre', 'A_veces', 'No_sabe'),
(194, 194, 2, 'Siempre', 'Siempre', 'No_sabe'),
(195, 195, 2, 'Nunca', 'A_veces', 'No_sabe'),
(196, 196, 0, 'Siempre', 'Nunca', 'No_sabe'),
(197, 197, 2, 'Nunca', 'A_veces', 'No_sabe'),
(198, 198, 0, 'A_veces', 'Siempre', 'No_sabe'),
(199, 199, 0, 'A_veces', 'A_veces', 'No_sabe'),
(200, 200, 2, 'Siempre', 'A_veces', 'No_sabe');

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
-- Indices de la tabla `vih_cuestionario_vih`
--
ALTER TABLE `vih_cuestionario_vih`
  ADD PRIMARY KEY (`id_cuestionario`);

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
  MODIFY `idcentinela` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1778;

--
-- AUTO_INCREMENT de la tabla `sis_menus`
--
ALTER TABLE `sis_menus`
  MODIFY `idmenu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `sis_permisos`
--
ALTER TABLE `sis_permisos`
  MODIFY `idpermisos` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `sis_permisos_extras`
--
ALTER TABLE `sis_permisos_extras`
  MODIFY `idpermiso` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `sis_personal`
--
ALTER TABLE `sis_personal`
  MODIFY `idpersona` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sis_recursos`
--
ALTER TABLE `sis_recursos`
  MODIFY `idrecurso` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
  MODIFY `idsesion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `sis_submenus`
--
ALTER TABLE `sis_submenus`
  MODIFY `idsubmenu` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

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
-- AUTO_INCREMENT de la tabla `vih_cuestionario_vih`
--
ALTER TABLE `vih_cuestionario_vih`
  MODIFY `id_cuestionario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT de la tabla `vih_datos_sociodemograficos`
--
ALTER TABLE `vih_datos_sociodemograficos`
  MODIFY `id_sociodemografico` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

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
  MODIFY `id_factores_riesgo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT de la tabla `vih_informacion_clinica`
--
ALTER TABLE `vih_informacion_clinica`
  MODIFY `id_clinica` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT de la tabla `vih_modelo_prediccion_distrito`
--
ALTER TABLE `vih_modelo_prediccion_distrito`
  MODIFY `id_modelo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `vih_paciente`
--
ALTER TABLE `vih_paciente`
  MODIFY `id_paciente` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT de la tabla `vih_personal_medico`
--
ALTER TABLE `vih_personal_medico`
  MODIFY `id_personal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
  MODIFY `id_riesgo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
