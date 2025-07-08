<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mapa de Calor - Dengue | Moyobamba</title>

    <!-- Bootstrap 4.6 CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.css" />
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --success-gradient: linear-gradient(45deg, #56ab2f, #a8e6cf);
            --danger-gradient: linear-gradient(45deg, #ff6b6b, #ee5a24);
            --info-gradient: linear-gradient(45deg, #74b9ff, #0984e3);
            --warning-gradient: linear-gradient(45deg, #fdcb6e, #e17055);
            --shadow-soft: 0 4px 20px rgba(0, 0, 0, 0.1);
            --shadow-medium: 0 8px 30px rgba(0, 0, 0, 0.15);
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            height: 100vh;
            overflow: hidden;
        }

        .main-container {
            display: flex;
            height: 100vh;
            background: white;
            box-shadow: var(--shadow-medium);
        }

        /* SIDEBAR STYLES */
        .sidebar {
            width: 380px;
            background: var(--primary-gradient);
            color: white;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .sidebar-header {
            padding: 25px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(0, 0, 0, 0.1);
        }

        .sidebar-header h4 {
            margin: 0 0 8px 0;
            font-weight: 700;
            font-size: 1.3rem;
        }

        .sidebar-header .subtitle {
            opacity: 0.9;
            font-size: 0.9rem;
        }

        .sidebar-content {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
        }

        .section-title {
            font-size: 1rem;
            font-weight: 600;
            margin: 0 0 15px 0;
            padding-bottom: 8px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.3);
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 8px;
            font-size: 1.1rem;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-size: 0.9rem;
            font-weight: 500;
            opacity: 0.9;
        }

        .form-control,
        .custom-select {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            font-size: 0.9rem;
            border-radius: 8px;
            padding: 10px 12px;
            backdrop-filter: blur(10px);
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .custom-select:focus {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.6);
            box-shadow: 0 0 0 3px rgba(255, 255, 255, 0.1);
            color: white;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .custom-select option {
            background: #667eea;
            color: white;
        }

        .btn-primary-custom {
            background: var(--success-gradient);
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 8px;
            padding: 12px 20px;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-size: 0.85rem;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
        }

        .btn-outline-light-custom {
            background: transparent;
            border: 2px solid rgba(255, 255, 255, 0.3);
            color: white;
            font-weight: 500;
            border-radius: 8px;
            padding: 10px 18px;
            transition: all 0.3s ease;
            font-size: 0.85rem;
        }

        .btn-outline-light-custom:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.6);
            color: white;
        }

        .range-slider {
            width: 100%;
            height: 6px;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.3);
            outline: none;
            margin: 15px 0;
            cursor: pointer;
        }

        .range-slider::-webkit-slider-thumb {
            appearance: none;
            width: 20px;
            height: 20px;
            background: white;
            border-radius: 50%;
            cursor: pointer;
            box-shadow: var(--shadow-soft);
            transition: all 0.2s ease;
        }

        .range-slider::-webkit-slider-thumb:hover {
            transform: scale(1.2);
        }

        .health-centers-section {
            /* max-height: 280px; */
            overflow-y: auto;
            margin-top: 10px;
        }

        .health-center-item {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
        }

        .health-center-item:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateX(5px);
        }

        .health-center-name {
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 5px;
        }

        .health-center-stats {
            font-size: 0.8rem;
            opacity: 0.9;
        }

        .current-badge {
            background: var(--info-gradient);
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 12px;
            margin-right: 5px;
            font-weight: 600;
        }

        .prediction-badge {
            background: var(--danger-gradient);
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 12px;
            font-weight: 600;
        }

        .update-info {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            padding: 15px;
            margin-top: 20px;
            border-left: 4px solid #ffc107;
            backdrop-filter: blur(10px);
        }

        /* MAP AREA STYLES */
        .map-area {
            flex: 1;
            position: relative;
            background: #f8f9fa;
        }

        #dengue-map {
            height: 100%;
            width: 100%;
        }

        .top-controls {
            position: absolute;
            top: 20px;
            left: 20px;
            right: 20px;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            pointer-events: none;
        }

        .data-type-controls {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 20px;
            box-shadow: var(--shadow-medium);
            backdrop-filter: blur(15px);
            pointer-events: auto;
            min-width: 220px;
        }

        .data-type-controls h6 {
            margin: 0 0 15px 0;
            color: #495057;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .data-type-btn {
            width: 100%;
            border: 2px solid #667eea;
            color: #667eea;
            background: transparent;
            transition: all 0.3s ease;
            font-size: 0.85rem;
            padding: 8px 15px;
            border-radius: 25px;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .data-type-btn.active {
            background: var(--primary-gradient);
            color: white;
            border-color: transparent;
            transform: scale(1.02);
        }

        .data-type-btn:hover {
            background: var(--primary-gradient);
            color: white;
            border-color: transparent;
        }

        .stats-panel {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 20px;
            box-shadow: var(--shadow-medium);
            backdrop-filter: blur(15px);
            pointer-events: auto;
            min-width: 280px;
        }

        .stats-panel h6 {
            margin: 0 0 15px 0;
            color: #495057;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .stat-card {
            background: var(--primary-gradient);
            color: white;
            border-radius: 10px;
            padding: 15px;
            text-align: center;
            transition: transform 0.3s ease;
            margin-bottom: 12px;
            box-shadow: var(--shadow-soft);
        }

        .stat-card:hover {
            transform: translateY(-2px);
        }

        .stat-number {
            font-size: 1.8rem;
            font-weight: 700;
            display: block;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.8rem;
            opacity: 0.9;
            font-weight: 500;
        }

        .bottom-controls {
            position: absolute;
            bottom: 20px;
            left: 20px;
            right: 20px;
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            pointer-events: none;
        }

        .floating-controls {
            display: flex;
            flex-direction: column;
            pointer-events: auto;
        }

        .control-btn {
            background: rgba(255, 255, 255, 0.95);
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow-soft);
            color: #495057;
            font-size: 1.1rem;
        }

        .control-btn:hover {
            background: var(--primary-gradient);
            color: white;
            transform: scale(1.1);
        }

        .legend {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 20px;
            box-shadow: var(--shadow-medium);
            backdrop-filter: blur(15px);
            pointer-events: auto;
            min-width: 200px;
        }

        .legend h6 {
            margin: 0 0 15px 0;
            color: #495057;
            font-weight: 600;
            font-size: 0.95rem;
        }

        .legend-item {
            display: flex;
            align-items: center;
            margin: 8px 0;
            font-size: 0.85rem;
            color: #495057;
        }

        .legend-color {
            width: 25px;
            height: 15px;
            margin-right: 10px;
            border-radius: 4px;
            border: 1px solid rgba(0, 0, 0, 0.1);
            box-shadow: var(--shadow-soft);
        }

        /* NOTIFICATION STYLES */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 320px;
            padding: 15px 20px;
            border-radius: 8px;
            color: white;
            font-weight: 500;
            box-shadow: var(--shadow-medium);
            transform: translateX(400px);
            transition: transform 0.4s ease;
        }

        .notification.show {
            transform: translateX(0);
        }

        .notification.success {
            background: var(--success-gradient);
        }

        .notification.error {
            background: var(--danger-gradient);
        }

        .notification.info {
            background: var(--info-gradient);
        }

        .notification.warning {
            background: var(--warning-gradient);
        }

        /* RESPONSIVE DESIGN */
        @media (max-width: 768px) {
            .main-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                height: auto;
                max-height: 50vh;
                order: 2;
            }

            .map-area {
                order: 1;
                height: 50vh;
            }

            .top-controls {
                flex-direction: column;
                align-items: stretch;
            }

            .data-type-controls,
            .stats-panel {
                margin-bottom: 10px;
                min-width: auto;
            }

            .bottom-controls {
                position: relative;
                margin: 10px;
            }

            .floating-controls {
                flex-direction: row;
                justify-content: center;
            }

            .control-btn {
                margin: 0 5px;
            }

            .legend {
                margin-top: 10px;
                min-width: auto;
            }
        }

        /* CUSTOM SCROLLBAR */
        .sidebar-content::-webkit-scrollbar,
        .health-centers-section::-webkit-scrollbar {
            width: 6px;
        }

        .sidebar-content::-webkit-scrollbar-track,
        .health-centers-section::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 3px;
        }

        .sidebar-content::-webkit-scrollbar-thumb,
        .health-centers-section::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 3px;
        }

        .sidebar-content::-webkit-scrollbar-thumb:hover,
        .health-centers-section::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.5);
        }

        /* LOADING ANIMATION */
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }

        /* FADE IN ANIMATION */
        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>

<body>
    <div class="main-container">
        <!-- SIDEBAR DE CONTROLES -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h4><i class="fas fa-virus mr-2"></i>Mapa de Casos - VIH</h4>
                <div class="subtitle">
                    <i class="fas fa-map-marker-alt mr-1"></i>Moyobamba, San Martín
                    <!-- <span class="ml-2"><i class="fas fa-clock mr-1"></i>Actualizado: 07/07/2025</span> -->
                </div>
            </div>

            <div class="sidebar-content">
                <!-- PERÍODO DE TIEMPO -->
                <div class="section-title">
                    <i class="fas fa-calendar-range"></i>
                    Período de Análisis
                </div>

                <div class="row">
                    <!-- SELECTOR DE PREDICCIONES -->
                    <div class="col-12">
                        <div class="form-group">
                            <label for="prediccion-select">Seleccionar Predicción</label>
                            <select id="prediccion-select" class="custom-select px-4 py-0">
                                <?php
                                foreach ($data["predicciones"] as $prediccion) {
                                    echo "<option value='" . $prediccion["id_prediccion_modelo"] . "'>" . $prediccion["fecha_prediccion"] . "</option>";
                                }
                                ?>
                            </select>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label>Fecha Inicio</label>
                            <input type="date" id="fecha-inicio" class="form-control" value="2025-05-01">
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="form-group">
                            <label>Fecha Fin</label>
                            <input type="date" id="fecha-fin" class="form-control" value="2025-07-07">
                        </div>
                    </div>
                </div>

                <!-- BOTONES DE ACCIÓN -->
                <div class="row mb-3">
                    <div class="col-6">
                        <button class="btn btn-primary-custom btn-block" onclick="applyFilters()">
                            <i class="fas fa-filter mr-1"></i>Aplicar
                        </button>
                    </div>
                    <div class="col-6">
                        <button class="btn btn-outline-light-custom btn-block" onclick="resetFilters()">
                            <i class="fas fa-undo mr-1"></i>Reset
                        </button>
                    </div>
                </div>

                <div class="row">
                    <!-- <div class="col-6">
                        <button class="btn btn-outline-light-custom btn-block" onclick="exportData()">
                            <i class="fas fa-download mr-1"></i>Exportar
                        </button>
                    </div> -->
                    <div class="col-6">
                        <button class="btn btn-outline-light-custom btn-block" onclick="refreshData()">
                            <i class="fas fa-sync-alt mr-1"></i>Actualizar
                        </button>
                    </div>
                </div>

                <!-- CENTROS DE SALUD -->
                <div class="section-title">
                    <i class="fas fa-hospital-symbol"></i>
                    Centros de Salud
                </div>

                <div class="health-centers-section" id="health-centers-list">
                    <!-- Se carga dinámicamente -->
                </div>

                <!-- INFORMACIÓN DE ACTUALIZACIÓN -->
                <div class="update-info d-none">
                    <div class="d-flex align-items-center mb-2">
                        <i class="fas fa-info-circle mr-2"></i>
                        <strong>Información del Sistema</strong>
                    </div>
                    <small>
                        <div><strong>Última actualización:</strong> 07/07/2025 - 10:30 AM</div>
                        <div><strong>Próxima actualización:</strong> 14/07/2025</div>
                        <div><strong>Frecuencia:</strong> Semanal</div>
                        <div class="mt-2" style="opacity: 0.9;">
                            <em>Los datos se actualizan automáticamente cada semana con información validada del MINSA.</em>
                        </div>
                    </small>
                </div>
            </div>
        </div>

        <!-- ÁREA DEL MAPA -->
        <div class="map-area">
            <div id="dengue-map"></div>

            <!-- CONTROLES SUPERIORES -->
            <div class="top-controls d-none">
                <!-- Controles de Tipo de Datos -->
                <div class="data-type-controls fade-in">
                    <h6><i class="fas fa-layer-group mr-2"></i>Tipo de Visualización</h6>
                    <button type="button" class="btn data-type-btn active" id="btn-current" onclick="toggleDataType('current')">
                        <i class="fas fa-circle mr-2" style="color: #74b9ff;"></i>Casos Actuales
                    </button>
                    <button type="button" class="btn data-type-btn" id="btn-predicted" onclick="toggleDataType('predicted')">
                        <i class="fas fa-circle mr-2" style="color: #ff6b6b;"></i>Casos Predichos
                    </button>
                    <button type="button" class="btn data-type-btn" id="btn-both" onclick="toggleDataType('both')">
                        <i class="fas fa-circle mr-2" style="color: #a29bfe;"></i>Vista Combinada
                    </button>
                </div>

                <!-- Panel de Estadísticas -->
                <div class="stats-panel fade-in">
                    <h6><i class="fas fa-chart-line mr-2"></i>Estadísticas en Tiempo Real</h6>

                    <div class="row">
                        <div class="col-6">
                            <div class="stat-card">
                                <span class="stat-number" id="total-current">0</span>
                                <div class="stat-label">Casos Actuales</div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-card">
                                <span class="stat-number" id="total-predicted">0</span>
                                <div class="stat-label">Predicción 3M</div>
                            </div>
                        </div>
                    </div>

                    <div class="mt-3">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <small style="color: #6c757d;">Centro más afectado:</small>
                            <span class="badge badge-danger" id="most-affected">-</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <small style="color: #6c757d;">Tendencia semanal:</small>
                            <span class="badge badge-warning" id="weekly-trend">+12%</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center">
                            <small style="color: #6c757d;">Nivel de alerta:</small>
                            <span class="badge badge-success" id="alert-level">Moderado</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- CONTROLES INFERIORES -->
            <div class="bottom-controls">
                <!-- Controles Flotantes -->
                <div class="floating-controls">
                    <button class="control-btn" onclick="centerToMoyobamba()" title="Centrar en Moyobamba">
                        <i class="fas fa-crosshairs"></i>
                    </button>
                    <button class="control-btn" onclick="toggleClusters()" title="Alternar clusters">
                        <i class="fas fa-th"></i>
                    </button>
                    <button class="control-btn" onclick="toggleFullscreen()" title="Pantalla completa">
                        <i class="fas fa-expand"></i>
                    </button>
                    <button class="control-btn" onclick="toggleHeatmap()" title="Alternar mapa de calor">
                        <i class="fas fa-fire"></i>
                    </button>
                </div>

                <!-- Leyenda -->
                <div class="legend fade-in">
                    <h6><i class="fas fa-palette mr-2"></i>Nivel de Casos VIH</h6>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #e8f5e8;"></div>
                        <span>Sin casos (0)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #4caf50;"></div>
                        <span>Nivel Bajo (1-3 casos)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #ff9800;"></div>
                        <span>Nivel Medio (4-8 casos)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #f44336;"></div>
                        <span>Nivel Alto (9-15 casos)</span>
                    </div>
                    <div class="legend-item">
                        <div class="legend-color" style="background: #b71c1c;"></div>
                        <span>Nivel Muy Alto (15+ casos)</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.2/js/bootstrap.bundle.min.js"></script>
    <!-- Leaflet JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/leaflet.js"></script>
    <!-- Leaflet Heat Plugin -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet.heat/0.2.0/leaflet-heat.js"></script>

    <script>
        // VARIABLES GLOBALES
        let map;
        let currentHeatLayer, predictedHeatLayer, bothHeatLayer;
        let markersLayer;
        let currentDataType = 'current';
        let showClusters = false;
        let showHeatmapLayer = true;

        // Coordenadas de Moyobamba
        const MOYOBAMBA_COORDS = [-6.0344, -76.9728];

        // Datos de centros de salud en Moyobamba
        let healthCenters = [{
                id: 1,
                name: "Hospital Moyobamba",
                coords: [-6.041388710814162, -76.97079533836434],
                currentCases: 0,
                // predictedCases: 25,
                address: "Jr. San Martín 401, Moyobamba",
                type: "Hospital",
                capacity: 0
            },
            {
                id: 2,
                name: "Puesto de Salud I-1 Tahuishco",
                coords: [-6.02290566461403, -76.96637396559818],
                currentCases: 12,
                predictedCases: 18,
                address: "Circunvalación",
                type: "Centro de Salud",
                capacity: 0
            },
            {
                id: 3,
                name: "Centro de Salud Calzada - MINSA",
                coords: [-6.0345596919795215, -77.06657733248478],
                currentCases: 8,
                predictedCases: 13,
                address: "Puesto de Salud Calzada",
                type: "Puesto de Salud",
                capacity: 0
            },
            {
                id: 4,
                name: "Puesto de Salud San Marcos - Soritor",
                coords: [-6.136356974909148, -77.10410870828785],
                // currentCases: 15,
                // predictedCases: 22,
                // address: "Av. Zaragoza 789, Moyobamba",
                type: "Centro de Salud",
                capacity: 0
            },
            {
                id: 5,
                name: "Centro de Salud Habana",
                coords: [-6.080393023720227, -77.09056675813851],
                // currentCases: 6,
                // predictedCases: 9,
                address: "",
                type: "Centro de Salud",
                capacity: 0
            },
            {
                id: 6,
                name: "Centro de Salud Jepelacio",
                coords: [-6.113987447999908, -76.84942086840466],
                currentCases: 10,
                predictedCases: 16,
                address: "Jr. Principal, Jepelacio",
                type: "Centro de Salud",
                capacity: 0
            },
        ];

        // FUNCIÓN PARA INICIALIZAR EL MAPA
        function initializeMap() {
            // Crear mapa centrado en Moyobamba
            map = L.map('dengue-map').setView(MOYOBAMBA_COORDS, 15);

            // Agregar capa base
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '© OpenStreetMap contributors'
            }).addTo(map);

            // Agregar marcador de Moyobamba
            L.marker(MOYOBAMBA_COORDS)
                .addTo(map)
                .bindPopup(`
                    <div class="text-center">
                        <h6><i class="fas fa-city mr-2"></i>Moyobamba</h6>
                        <small>Capital de la Provincia de Moyobamba<br>Departamento de San Martín</small>
                    </div>
                `);

            // Cargar datos iniciales - sin datos automáticos
            healthCenters = []; // Vaciar el array
            loadHealthCentersList();
            // No cargar datos automáticamente
            showNotification('Selecciona un rango de fechas y modelo para ver los datos', 'info');
        }

        // FUNCIÓN PARA CREAR DATOS DE HEATMAP POR TIPO
        // REEMPLAZAR ESTA FUNCIÓN:
        function createHeatmapData(dataType) {
            console.log("dataType:", dataType);

            return healthCenters.map(center => {
                let cases;
                switch (dataType) {
                    case 'current':
                        cases = center.currentCases || 0;
                        break;
                    case 'predicted':
                        cases = center.predictedCases || 0;
                        break;
                    case 'both':
                        cases = (center.currentCases || 0) + (center.predictedCases || 0);
                        break;
                }

                // Normalizar la intensidad según el nivel (0.0 a 1.0)
                let intensity;
                if (cases === 0) intensity = 0.0;
                else if (cases <= 3) intensity = 0.25;
                else if (cases <= 8) intensity = 0.5;
                else if (cases <= 15) intensity = 0.75;
                else intensity = 1.0;

                return [center.coords[0], center.coords[1], intensity];
            });
        }

        // FUNCIÓN PARA ALTERNAR TIPO DE DATOS
        function toggleDataType(type) {
            currentDataType = type;

            // Actualizar botones
            document.querySelectorAll('.data-type-btn').forEach(btn => btn.classList.remove('active'));
            document.getElementById(`btn-${type}`).classList.add('active');

            // Limpiar capas existentes
            if (currentHeatLayer) map.removeLayer(currentHeatLayer);
            if (predictedHeatLayer) map.removeLayer(predictedHeatLayer);
            if (bothHeatLayer) map.removeLayer(bothHeatLayer);

            if (showHeatmapLayer && healthCenters.length > 0) {
                // Crear nueva capa según el tipo
                const heatData = createHeatmapData(type);
                const gradient = getGradientByType(type);

                const heatLayer = L.heatLayer(heatData, {
                    radius: 35,
                    blur: 1,
                    maxZoom: 17,
                    minOpacity: 0.8,
                    max: 1.0,
                    gradient: gradient
                });

                // Asignar y mostrar la capa correspondiente
                switch (type) {
                    case 'current':
                        currentHeatLayer = heatLayer;
                        break;
                    case 'predicted':
                        predictedHeatLayer = heatLayer;
                        break;
                    case 'both':
                        bothHeatLayer = heatLayer;
                        break;
                }

                heatLayer.addTo(map);
            }

            updateStats();
        }

        // FUNCIÓN PARA OBTENER GRADIENTE POR TIPO DE DATOS
        // REEMPLAZAR ESTA FUNCIÓN:
        function getGradientByType(type) {
            switch (type) {
                case 'current':
                    return {
                        0.0: '#e8f5e8', // Gris claro (sin casos)
                            0.25: '#4caf50', // Verde (bajo)
                            0.5: '#ff9800', // Naranja (medio)
                            0.75: '#f44336', // Rojo (alto)
                            1.0: '#b71c1c' // Rojo oscuro (muy alto)
                    };
                case 'predicted':
                    return {
                        0.0: '#fce4ec', // Rosa muy claro
                            0.25: '#e91e63', // Rosa (bajo)
                            0.5: '#ff5722', // Naranja rojizo (medio)
                            0.75: '#d32f2f', // Rojo (alto)
                            1.0: '#8e0000' // Rojo muy oscuro (muy alto)
                    };
                case 'both':
                    return {
                        0.0: '#f3e5f5', // Púrpura muy claro
                            0.25: '#9c27b0', // Púrpura (bajo)
                            0.5: '#ff6f00', // Naranja oscuro (medio)
                            0.75: '#e65100', // Naranja rojizo (alto)
                            1.0: '#bf360c' // Rojo ladrillo (muy alto)
                    };
            }
        }

        // FUNCIÓN PARA CARGAR LISTA DE CENTROS DE SALUD
        function loadHealthCentersList() {
            const container = document.getElementById('health-centers-list');
            container.innerHTML = '';

            if (healthCenters.length === 0) {
                container.innerHTML = `
            <div class="text-center text-muted p-3" style="color: rgba(255,255,255,0.8);">
                <i class="fas fa-info-circle mb-2"></i><br>
                <small>Aplica filtros para ver los centros de salud</small>
            </div>
        `;
                return;
            }

            healthCenters.forEach(center => {
                const item = document.createElement('div');
                item.className = 'health-center-item';
                item.onclick = () => focusOnCenter(center.id);

                item.innerHTML = `
            <div class="health-center-name">${center.name}</div>
            <div class="health-center-stats">
                <span class="current-badge">${center.currentCases || 0} actuales</span>
                <span class="prediction-badge">${center.predictedCases || 0} predichos</span>
                <br><small class="text-muted">${center.type} - ${center.address || ''}</small>
            </div>
        `;

                container.appendChild(item);
            });
        }

        // FUNCIÓN PARA ENFOCAR EN UN CENTRO DE SALUD
        function focusOnCenter(centerId) {
            const center = healthCenters.find(c => c.id === centerId);
            if (center) {
                map.setView(center.coords, 16);

                const popup = L.popup()
                    .setLatLng(center.coords)
                    .setContent(`
                        <div class="text-center">
                            <h6><i class="fas fa-hospital mr-2"></i>${center.name}</h6>
                            <div class="mb-2">
                                <span class="badge badge-info">${center.type}</span>
                            </div>
                            <div class="mb-2">
                                <small><i class="fas fa-map-marker-alt mr-1"></i>${center.address}</small>
                            </div>
                            <hr class="my-2">
                            <div class="row text-center">
                                <div class="col-6">
                                    <strong class="text-primary">${center.currentCases}</strong><br>
                                    <small>Casos Actuales</small>
                                </div>
                                <div class="col-6">
                                    <strong class="text-danger">${center.predictedCases}</strong><br>
                                    <small>Predicción</small>
                                </div>
                            </div>
                            <div class="mt-2">
                                <small><i class="fas fa-bed mr-1"></i>Capacidad: ${center.capacity} camas</small>
                            </div>
                        </div>
                    `)
                    .openOn(map);
            }
        }

        // FUNCIÓN PARA ACTUALIZAR ESTADÍSTICAS
        function updateStats() {
            const totalCurrent = healthCenters.reduce((sum, center) => sum + (center.currentCases || 0), 0);
            const totalPredicted = healthCenters.reduce((sum, center) => sum + (center.predictedCases || 0), 0);

            if (healthCenters.length === 0) {
                document.getElementById('total-current').textContent = '0';
                document.getElementById('total-predicted').textContent = '0';
                document.getElementById('most-affected').textContent = '-';
                return;
            }

            const mostAffected = healthCenters.reduce((max, center) =>
                (center.currentCases || 0) > (max.currentCases || 0) ? center : max
            );

            document.getElementById('total-current').textContent = totalCurrent;
            document.getElementById('total-predicted').textContent = totalPredicted;
            document.getElementById('most-affected').textContent = mostAffected.name || '-';
        }

        // AGREGAR ESTAS FUNCIONES NUEVAS:
        function getColorByLevel(cases) {
            if (cases === 0) return '#e8f5e8'; // Gris muy claro para 0 casos
            if (cases <= 3) return '#4caf50'; // Verde - Nivel Bajo
            if (cases <= 8) return '#ff9800'; // Naranja - Nivel Medio
            if (cases <= 15) return '#f44336'; // Rojo - Nivel Alto
            return '#b71c1c'; // Rojo oscuro - Nivel Muy Alto
        }

        function getAlertLevel(cases) {
            if (cases === 0) return 'Sin casos';
            if (cases <= 3) return 'Bajo';
            if (cases <= 8) return 'Medio';
            if (cases <= 15) return 'Alto';
            return 'Muy Alto';
        }

        // FUNCIÓN PARA APLICAR FILTROS - ACTUALIZADA CON FETCH
        async function applyFilters() {
            const fechaInicio = document.getElementById('fecha-inicio').value;
            const fechaFin = document.getElementById('fecha-fin').value;
            const prediccionSelect = document.getElementById('prediccion-select').value;

            if (!fechaInicio || !fechaFin || !prediccionSelect) {
                showNotification('Por favor completa todos los campos', 'warning');
                return;
            }

            // Deshabilitar botón mientras se carga
            const applyBtn = document.querySelector('.btn-primary-custom');
            const originalText = applyBtn.innerHTML;
            applyBtn.disabled = true;
            applyBtn.innerHTML = '<span class="loading-spinner"></span> Cargando...';

            try {
                const response = await fetch('/admin/mapa/predicciones', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({
                        fecha_inicio: fechaInicio,
                        fecha_fin: fechaFin,
                        id_prediccion: prediccionSelect
                    })
                });

                const data = await response.json();
                console.log(data);


                if (data.status) {
                    // Actualizar datos de centros de salud
                    if (data.data.centros_salud && data.data.centros_salud.length > 0) {
                        healthCenters = data.data.centros_salud;
                    }

                    // Recargar lista y mapa
                    loadHealthCentersList();
                    toggleDataType(currentDataType);
                    updateStats();

                    // Mostrar estadísticas del resumen
                    if (data.data.resumen) {
                        document.getElementById('total-current').textContent = data.data.resumen.total_casos_actuales || 0;
                        document.getElementById('total-predicted').textContent = data.data.resumen.total_casos_predichos || 0;
                    }

                    showNotification('Filtros aplicados correctamente', 'success');
                } else {
                    showNotification(data.message || 'Error al aplicar filtros', 'error');
                }

            } catch (error) {
                console.error('Error:', error);
                showNotification('Error de conexión al aplicar filtros', 'error');
            } finally {
                // Restaurar botón
                applyBtn.disabled = false;
                applyBtn.innerHTML = originalText;
            }
        }

        // FUNCIÓN PARA RESETEAR FILTROS
        function resetFilters() {
            document.getElementById('fecha-inicio').value = '2025-05-01';
            document.getElementById('fecha-fin').value = '2025-07-07';
            toggleDataType(currentDataType);
            showNotification('Filtros restablecidos', 'info');
        }

        // FUNCIÓN PARA CENTRAR EN MOYOBAMBA
        function centerToMoyobamba() {
            map.setView(MOYOBAMBA_COORDS, 13);
        }

        // FUNCIÓN PARA ALTERNAR CLUSTERS
        function toggleClusters() {
            showClusters = !showClusters;

            if (markersLayer) {
                map.removeLayer(markersLayer);
            }

            if (showClusters) {
                markersLayer = L.layerGroup();

                healthCenters.forEach(center => {
                    let cases, color;

                    switch (currentDataType) {
                        case 'current':
                            cases = center.currentCases || 0;
                            color = getColorByLevel(cases); // <-- CAMBIAR ESTA LÍNEA
                            break;
                        case 'predicted':
                            cases = center.predictedCases || 0;
                            color = getColorByLevel(cases); // <-- CAMBIAR ESTA LÍNEA
                            break;
                        case 'both':
                            cases = (center.currentCases || 0) + (center.predictedCases || 0);
                            color = getColorByLevel(cases); // <-- CAMBIAR ESTA LÍNEA
                            break;
                    }

                    const marker = L.circleMarker(center.coords, {
                        radius: Math.sqrt(cases) * 2 + 5,
                        fillColor: color,
                        color: '#fff',
                        weight: 2,
                        opacity: 1,
                        fillOpacity: 0.8
                    });

                    marker.bindPopup(`
                        <div class="text-center">
                            <h6><i class="fas fa-hospital mr-2"></i>${center.name}</h6>
                            <div class="mb-2">
                                <span class="badge badge-secondary">${center.type}</span>
                            </div>
                            <hr class="my-2">
                            <div class="row">
                                <div class="col-6 text-center">
                                    <strong class="text-primary">${center.currentCases}</strong><br>
                                    <small>Actuales</small>
                                </div>
                                <div class="col-6 text-center">
                                    <strong class="text-danger">${center.predictedCases}</strong><br>
                                    <small>Predichos</small>
                                </div>
                            </div>
                        </div>
                    `);

                    markersLayer.addLayer(marker);
                });

                markersLayer.addTo(map);
            }
        }

        // FUNCIÓN PARA ALTERNAR HEATMAP
        function toggleHeatmap() {
            showHeatmapLayer = !showHeatmapLayer;

            if (showHeatmapLayer) {
                toggleDataType(currentDataType);
                showNotification('Mapa de calor activado', 'info');
            } else {
                if (currentHeatLayer) map.removeLayer(currentHeatLayer);
                if (predictedHeatLayer) map.removeLayer(predictedHeatLayer);
                if (bothHeatLayer) map.removeLayer(bothHeatLayer);
                showNotification('Mapa de calor desactivado', 'info');
            }
        }

        // FUNCIÓN PARA PANTALLA COMPLETA
        function toggleFullscreen() {
            if (!document.fullscreenElement) {
                document.documentElement.requestFullscreen().then(() => {
                    setTimeout(() => map.invalidateSize(), 100);
                });
            } else {
                document.exitFullscreen().then(() => {
                    setTimeout(() => map.invalidateSize(), 100);
                });
            }
        }

        // FUNCIÓN PARA EXPORTAR DATOS
        function exportData() {
            const csvHeader = "ID,Nombre,Tipo,Dirección,Latitud,Longitud,Casos_Actuales,Casos_Predichos,Capacidad\n";
            const csvData = healthCenters.map(center =>
                `${center.id},"${center.name}","${center.type}","${center.address}",${center.coords[0]},${center.coords[1]},${center.currentCases},${center.predictedCases},${center.capacity}`
            ).join("\n");

            const csvContent = "data:text/csv;charset=utf-8," + csvHeader + csvData;
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", `dengue_moyobamba_${new Date().toISOString().split('T')[0]}.csv`);
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            showNotification('Datos exportados correctamente', 'success');
        }

        // FUNCIÓN PARA REFRESCAR DATOS
        function refreshData() {
            // Simular carga de nuevos datos
            healthCenters.forEach(center => {
                const variation = Math.floor(Math.random() * 3) - 1; // -1, 0, or 1
                center.currentCases = Math.max(0, center.currentCases + variation);
            });

            loadHealthCentersList();
            toggleDataType(currentDataType);
            updateStats();

            showNotification('Datos actualizados correctamente', 'success');
        }

        // FUNCIÓN PARA MOSTRAR NOTIFICACIONES
        function showNotification(message, type = 'info') {
            const notification = document.createElement('div');
            notification.className = `notification ${type}`;

            const icon = type === 'success' ? 'check-circle' :
                type === 'error' ? 'exclamation-circle' :
                type === 'warning' ? 'exclamation-triangle' : 'info-circle';

            notification.innerHTML = `
                <i class="fas fa-${icon} mr-2"></i>
                ${message}
            `;

            document.body.appendChild(notification);

            // Mostrar notificación
            setTimeout(() => notification.classList.add('show'), 100);

            // Ocultar y remover después de 3 segundos
            setTimeout(() => {
                notification.classList.remove('show');
                setTimeout(() => notification.remove(), 400);
            }, 3000);
        }

        // INICIALIZACIÓN CUANDO EL DOM ESTÉ LISTO
        document.addEventListener('DOMContentLoaded', function() {
            initializeMap();

            // Simular actualización automática cada 5 minutos
            setInterval(() => {
                healthCenters.forEach(center => {
                    const variation = Math.floor(Math.random() * 3) - 1;
                    center.currentCases = Math.max(0, center.currentCases + variation);
                });

                if (currentDataType === 'current' || currentDataType === 'both') {
                    toggleDataType(currentDataType);
                }
                updateStats();
            }, 300000); // 5 minutos
        });
    </script>
</body>

</html>