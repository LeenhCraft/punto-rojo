<?php header_web('Template.HeaderDashboard', $data); ?>
<style>
    /* Estilos adicionales para mejorar la apariencia */
    .table-hover tbody tr:hover {
        background-color: rgba(0, 123, 255, 0.05);
    }

    .table thead th {
        border-bottom: 2px solid #dee2e6;
        font-weight: 600;
        color: #495057;
    }

    .btn-group .btn {
        margin-right: 2px;
    }

    .btn-group .btn:last-child {
        margin-right: 0;
    }

    .progress {
        background-color: #e9ecef;
        border-radius: 4px;
    }

    .badge {
        padding: 0.5rem 0.75rem;
    }

    @media (max-width: 768px) {
        .table-responsive {
            font-size: 0.875rem;
        }

        .btn-group .btn {
            padding: 0.25rem 0.5rem;
        }
    }
</style>
<div class="container-fluid p-0">
    <div class="row justify-content-center">
        <div class="col-12">
            <!-- Header Card -->
            <div class="card header-card mb-4">
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <i
                            class="fas fa-heartbeat text-primary me-3"
                            style="font-size: 2rem"></i>
                        <h1 class="h2 mb-0 font-weight-bold">Predicción de VIH</h1>
                    </div>

                    <!-- Controls -->
                    <div class="d-flex align-items-center flex-wrap">
                        <div class="d-flex align-items-center me-4 mb-2">
                            <i class="fas fa-calendar-alt text-muted me-2"></i>
                            <label class="mb-0 me-2 font-weight-medium">Meses a futuro:</label>
                            <select
                                id="selectedMonths"
                                class="form-control form-control-sm"
                                style="width: auto">
                                <option value="3">3 meses</option>
                                <option value="6">6 meses</option>
                                <option value="12">12 meses</option>
                                <option value="24">24 meses</option>
                            </select>
                        </div>

                        <button
                            id="btnPredecir"
                            class="btn btn-primary btn-predecir mb-2">
                            <i class="fas fa-chart-line me-2"></i>
                            Predecir
                        </button>
                    </div>
                </div>
            </div>

            <!-- Table Card -->
            <div class="card table-card">
                <div class="card-header bg-white">
                    <h2 class="h5 mb-0 font-weight-semibold">
                        Predicciones Realizadas
                    </h2>
                </div>

                <div class="card-body p-0">
                    <div class="table-responsive">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="bg-light">
                                    <tr>
                                        <th scope="col">
                                            <i class="fas fa-robot me-2"></i>Modelo IA
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-calendar-alt me-2"></i>Fecha
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-chart-line me-2"></i>Casos Predichos
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-clock me-2"></i>Horizonte (Meses)
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-cogs me-2"></i>Acciones
                                        </th>
                                    </tr>
                                </thead>
                                <tbody id="predictionsTable">
                                    <?php if (!empty($data["predicciones"])): ?>
                                        <?php foreach ($data["predicciones"] as $prediccion): ?>
                                            <?php
                                            // Formatear la fecha
                                            $fecha_formateada = date('d/m/Y H:i', strtotime($prediccion['fecha_prediccion']));

                                            // Determinar el color del badge basado en el número de casos
                                            $badge_class = '';
                                            if ($prediccion['casos_predichos'] <= 10) {
                                                $badge_class = 'bg-success';
                                            } elseif ($prediccion['casos_predichos'] <= 20) {
                                                $badge_class = 'bg-warning';
                                            } else {
                                                $badge_class = 'bg-danger';
                                            }

                                            $progress_width = min(($prediccion['horizonte_prediccion_meses'] / 12) * 100, 100);
                                            ?>
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="bg-label-primary rounded-circle p-2 me-3">
                                                            <i class="fas fa-brain text-primary"></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-medium"><?= htmlspecialchars($prediccion['modelo_ia']) ?></div>
                                                            <small class="text-muted">ID: <?= $prediccion['id_prediccion_modelo'] ?></small>
                                                        </div>
                                                    </div>
                                                </td>

                                                <td>
                                                    <span class="text-nowrap"><?= $fecha_formateada ?></span>
                                                </td>

                                                <td>
                                                    <span class="badge <?= $badge_class ?> fs-6">
                                                        <?= number_format($prediccion['casos_predichos']) ?>
                                                    </span>
                                                </td>

                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="progress me-2" style="width: 60px; height: 8px;">
                                                            <div class="progress-bar bg-info" style="width: <?= $progress_width ?>%"></div>
                                                        </div>
                                                        <span class="fw-medium"><?= $prediccion['horizonte_prediccion_meses'] ?></span>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <button type="button" class="btn btn-sm btn-outline-primary"
                                                            title="Ver Mapa"
                                                            onclick="verMapa(<?= $prediccion['id_prediccion_modelo'] ?>)">
                                                            <i class="fas fa-location-dot"></i>
                                                        </button>
                                                        <button type="button" class="btn btn-sm btn-outline-secondary"
                                                            title="Descargar"
                                                            onclick="verDetalles(<?= $prediccion['id_prediccion_modelo'] ?>)">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    <?php else: ?>
                                        <tr>
                                            <td colspan="5" class="text-center py-4">
                                                <div class="text-muted">
                                                    <i class="fas fa-inbox fa-2x mb-2"></i>
                                                    <br>No hay predicciones disponibles
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endif; ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<?php footer_web('Template.FooterDashboard', $data); ?>

<script>
    // Funciones JavaScript para las acciones
    function verDetalles(id) {
        // Implementar lógica para ver detalles
        console.log('Ver detalles de predicción ID:', id);
        // Ejemplo: window.location.href = 'ver_prediccion.php?id=' + id;
    }

    function verMapa(id) {
        // Implementar lógica para descargar
        console.log('Descargar predicción ID:', id);
        // Ejemplo: window.location.href = 'descargar_prediccion.php?id=' + id;
    }
</script>