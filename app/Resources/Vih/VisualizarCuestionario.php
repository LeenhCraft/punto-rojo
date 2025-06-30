<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <title><?php echo $data['titulo_web'] ?? $_ENV["APP_NAME"]; ?></title>

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <!-- Icons. Uncomment required icon fonts -->
    <link rel="stylesheet" href="/css/boxicons.css" />
    <script src="https://kit.fontawesome.com/b4dffa1b79.js" crossorigin="anonymous"></script>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
        href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
        rel="stylesheet" />

    <link rel="stylesheet" href="/assets/vendor/fonts/iconify-icons.css" />

    <!-- Core CSS -->
    <!-- build:css assets/vendor/css/theme.css  -->

    <link rel="stylesheet" href="/assets/vendor/libs/pickr/pickr-themes.css" />

    <link rel="stylesheet" href="/assets/vendor/css/core.css" />
    <link rel="stylesheet" href="/assets/css/demo.css" />

    <link rel="stylesheet" href="/assets/vendor/css/pages/front-page.css" />

    <!-- Vendors CSS -->

    <!-- endbuild -->

    <link rel="stylesheet" href="/assets/vendor/libs/nouislider/nouislider.css" />
    <link rel="stylesheet" href="/assets/vendor/libs/swiper/swiper.css" />

    <!-- Page CSS -->

    <link rel="stylesheet" href="/assets/vendor/css/pages/front-page-landing.css" />

    <!-- Helpers -->
    <script src="/assets/vendor/js/helpers.js"></script>
    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->

    <!--? Template customizer: To hide customizer set displayCustomizer value false in config.js.  -->
    <script src="/assets/vendor/js/template-customizer.js"></script>

    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->

    <script src="/assets/js/front-config.js"></script>

    <?php
    if (isset($data['css']) && !empty($data['css'])) {
        for ($i = 0; $i < count($data['css']); $i++) {
            echo '<link rel="stylesheet" type="text/css" href="' . $data['css'][$i] . '">' . PHP_EOL;
        }
    }
    ?>

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .report-container {
            max-width: 1200px;
            margin: 20px auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .report-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .report-header h1 {
            margin: 0;
            font-size: 2.2rem;
            font-weight: bold;
            color: inherit;
        }

        .report-meta {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
        }

        .section-card {
            border: none;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .section-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
            display: flex;
            align-items: center;
        }

        .section-header i {
            margin-right: 10px;
            font-size: 1.2rem;
        }

        .section-header h5 {
            color: white;
        }

        .section-content {
            padding: 20px;
        }

        .info-row {
            display: flex;
            margin-bottom: 15px;
            border-bottom: 1px solid #f1f3f4;
            padding-bottom: 10px;
        }

        .info-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 200px;
            margin-bottom: 5px;
        }

        .info-value {
            color: #212529;
            flex: 1;
        }

        .badge-status {
            font-size: 0.875rem;
            padding: 0.375rem 0.75rem;
        }

        .risk-indicator {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            display: inline-block;
        }

        .risk-high {
            background-color: #f8d7da;
            color: #721c24;
        }

        .risk-medium {
            background-color: #fff3cd;
            color: #856404;
        }

        .risk-low {
            background-color: #d4edda;
            color: #155724;
        }

        .print-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }

        @media print {
            .print-btn {
                display: none;
            }

            .report-container {
                box-shadow: none;
                margin: 0;
            }
        }

        .empty-value {
            color: #6c757d;
            font-style: italic;
        }
    </style>
</head>

<body>
    <button class="btn btn-primary print-btn" onclick="window.print()">
        <i class="fas fa-print me-2"></i> Imprimir
    </button>

    <div class="report-container">
        <!-- Header -->
        <div class="report-header">
            <h1><i class="fas fa-file-medical-alt me-3"></i>Reporte de Cuestionario VIH</h1>
            <p class="mb-0 mt-2">Sistema de Seguimiento y Evaluación de Riesgos</p>
        </div>

        <!-- Meta información -->
        <div class="report-meta">
            <div class="row">
                <div class="col-md-3">
                    <strong>Número de Cuestionario:</strong><br>
                    <span class="text-primary" id="num-cuestionario"></span>
                </div>
                <div class="col-md-3">
                    <strong>Fecha de Aplicación:</strong><br>
                    <span id="fecha-aplicacion"></span>
                </div>
                <div class="col-md-3">
                    <strong>Estado:</strong><br>
                    <span class="badge badge-success badge-status" id="estado"></span>
                </div>
                <div class="col-md-3">
                    <strong>Personal Responsable:</strong><br>
                    <span id="personal"></span>
                </div>
            </div>
        </div>

        <div class="container-fluid p-4">
            <!-- Sección 1: Datos del Paciente -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-user"></i>
                    <h5 class="mb-0">Datos del Paciente</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Nombre Completo:</div>
                                <div class="info-value" id="nombre-completo"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Tipo de Documento:</div>
                                <div class="info-value" id="tipo-documento"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Número de Documento:</div>
                                <div class="info-value" id="numero-documento"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Fecha de Nacimiento:</div>
                                <div class="info-value" id="fecha-nacimiento"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Edad:</div>
                                <div class="info-value" id="edad"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Estado del Paciente:</div>
                                <div class="info-value">
                                    <span class="badge badge-success" id="paciente-activo"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección 2: Establecimiento de Salud -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-hospital"></i>
                    <h5 class="mb-0">Establecimiento de Salud</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Establecimiento:</div>
                                <div class="info-value" id="establecimiento"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Código:</div>
                                <div class="info-value" id="codigo-establecimiento"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Zona:</div>
                                <div class="info-value" id="zona"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Microred:</div>
                                <div class="info-value" id="microred"></div>
                            </div>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Dirección:</div>
                        <div class="info-value" id="direccion"></div>
                    </div>
                </div>
            </div>

            <!-- Sección 3: Datos Sociodemográficos -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-users"></i>
                    <h5 class="mb-0">Datos Sociodemográficos</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Sexo:</div>
                                <div class="info-value" id="sexo"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Estado Civil:</div>
                                <div class="info-value" id="estado-civil"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Nivel Educativo:</div>
                                <div class="info-value" id="nivel-educativo"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Ocupación Actual:</div>
                                <div class="info-value" id="ocupacion"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Lugar de Residencia:</div>
                                <div class="info-value" id="residencia"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección 4: Información Clínica -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-stethoscope"></i>
                    <h5 class="mb-0">Información Clínica</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Fecha de Diagnóstico VIH:</div>
                                <div class="info-value empty-value" id="fecha-diagnostico"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Tipo de Prueba:</div>
                                <div class="info-value empty-value" id="tipo-prueba"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Recibe TAR:</div>
                                <div class="info-value" id="recibe-tar">
                                    <span class="badge badge-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Último CD4:</div>
                                <div class="info-value" id="cd4"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Última Carga Viral:</div>
                                <div class="info-value" id="carga-viral"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Presenta ITS Actual:</div>
                                <div class="info-value" id="its-actual">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección 5: Factores de Riesgo -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h5 class="mb-0">Factores de Riesgo</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Uso de Preservativos (Pre-diagnóstico):</div>
                                <div class="info-value" id="preservativos-pre"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Relaciones sin Protección (Post-diagnóstico):</div>
                                <div class="info-value" id="relaciones-sin-proteccion">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Parejas Sexuales (Último año):</div>
                                <div class="info-value" id="parejas-anio"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Relaciones Mismo Sexo:</div>
                                <div class="info-value" id="mismo-sexo">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Uso de Drogas Inyectables:</div>
                                <div class="info-value" id="drogas-inyectables">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Transfusiones (Últimos 5 años):</div>
                                <div class="info-value" id="transfusiones">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Antecedentes de ITS:</div>
                                <div class="info-value" id="antecedentes-its">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Relaciones Ocasionales (Post-diagnóstico):</div>
                                <div class="info-value" id="relaciones-ocasionales">
                                    <span class="badge badge-success"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sección 6: Riesgo de Transmisión Actual -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-shield-alt"></i>
                    <h5 class="mb-0">Riesgo de Transmisión Actual</h5>
                </div>
                <div class="section-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Tiene Pareja Sexual Activa:</div>
                                <div class="info-value" id="pareja-activa">
                                    <span class="badge badge-secondary"></span>
                                </div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Informa Estado VIH:</div>
                                <div class="info-value" id="informa-vih"></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-row">
                                <div class="info-label">Uso de Preservativo Actual:</div>
                                <div class="info-value" id="preservativo-actual"></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Pareja se ha Realizado Prueba VIH:</div>
                                <div class="info-value" id="pareja-prueba"></div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-4 p-3 bg-light rounded">
                        <h6><i class="fas fa-chart-line me-2"></i>Evaluación de Riesgo</h6>
                        <div class="risk-indicator risk-medium" id="evaluacion-riesgo">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Observaciones -->
            <div class="card section-card">
                <div class="section-header">
                    <i class="fas fa-clipboard-list"></i>
                    <h5 class="mb-0">Observaciones Generales</h5>
                </div>
                <div class="section-content">
                    <div class="info-row">
                        <div class="info-value empty-value" id="observaciones">
                            Sin observaciones registradas
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="text-center p-3 bg-light">
            <small class="text-muted">
                Reporte generado el <span id="fecha-reporte"></span> |
                Sistema de Seguimiento VIH v1.0
            </small>
        </div>
    </div>

    <script>
        const base_url = "<?php echo base_url(); ?>";
    </script>

    <!-- Core JS -->
    <!-- build:js assets/vendor/js/theme.js  -->

    <script src="/js/jquery.min.js"></script>
    <script src="/js/popper.min.js"></script>
    <script src="/js/jquery.dataTables.min.js"></script>
    <script src="/js/dataTables.bootstrap.min.js"></script>

    <script src="/assets/vendor/libs/popper/popper.js"></script>
    <script src="/assets/vendor/js/bootstrap.js"></script>
    <script src="/assets/vendor/libs/@algolia/autocomplete-js.js"></script>
    <script src="/node_modules/sweetalert2/dist/sweetalert2.all.min.js"></script>
    <script src="/assets/vendor/libs/pickr/pickr.js"></script>

    <!-- endbuild -->

    <!-- Vendors JS -->
    <script src="/assets/vendor/libs/nouislider/nouislider.js"></script>
    <script src="/assets/vendor/libs/swiper/swiper.js"></script>

    <!-- Main JS -->

    <script src="/assets/js/front-main.js"></script>

    <!-- Page JS -->
    <!-- <script src="/assets/js/front-page-landing.js"></script> -->

    <script>
        const Toast = Swal.mixin({
            toast: true,
            position: "top-end",
            showConfirmButton: false,
            showCloseButton: true,
            timer: 5000,
            timerProgressBar: true,
            didOpen: (toast) => {
                toast.addEventListener("mouseenter", Swal.stopTimer);
                toast.addEventListener("mouseleave", Swal.resumeTimer);
            },
        });
        const datosEjemplo = <?php echo json_encode($data['resultado']); ?>;
    </script>

    <?php
    if (isset($data['js']) && !empty($data['js'])) {
        for ($i = 0; $i < count($data['js']); $i++) {
            echo '<script src="' . $data['js'][$i] . '"></script>' . PHP_EOL;
        }
    }
    ?>

</body>

</html>