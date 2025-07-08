<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="container mt-4">
    <h2 class="mb-4">Preparación de Datos (Datasets)</h2>
    <div class="card mb-4">
        <div class="card-body">
            <form id="form-preparar-datos">
                <!-- dos inputs para determinar la fecha de inicio y fin -->
                <div class="row mb-2">
                    <div class="form-group col-md-6">
                        <label for="fechaInicio">Fecha de Inicio</label>
                        <input type="date" class="form-control" id="fechaInicio" name="fechaInicio" required value="<?php echo date('Y-m-d'); ?>">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="fechaFin">Fecha de Fin</label>
                        <input type="date" class="form-control" id="fechaFin" name="fechaFin" required value="<?php echo date('Y-m-d'); ?>">
                    </div>
                </div>

                <!-- un input para el nombre del dataset -->
                <div class="form-group mb-2">
                    <label for="nombreDataset">Nombre del Dataset</label>
                    <input type="text" class="form-control" id="nombreDataset" name="nombreDataset" required placeholder="Ej: dataset_vih" value="dataset_vih.csv">
                </div>

                <div class="form-group mb-2">
                    <label for="tipoDatos">Archivo de salida para el Dataset</label>
                    <select class="form-control" id="tipoDatos" name="tipoDatos" required>
                        <option value="csv">CSV</option>
                        <option value="excel">Excel</option>
                    </select>
                    <small class="form-text text-muted">Selecciona el tipo de datos a importar.</small>
                </div>
                <button type="submit" class="btn btn-primary">Preparar Datos</button>
            </form>
        </div>
    </div>

    <h2 class="mb-4">Entrenamiento del Modelo XGBoost</h2>

    <!-- Configuración del modelo -->
    <div class="card mb-4">
        <div class="card-header">
            Configuración del Entrenamiento
        </div>
        <div class="card-body">
            <form id="form-entrenamiento">
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="learning_rate">Tasa de aprendizaje (learning_rate)</label>
                        <input type="number" step="0.01" min="0" max="1" class="form-control" id="learning_rate" name="learning_rate" placeholder="Ej: 0.1" required value="0.1">
                    </div>

                    <div class="form-group col-md-6">
                        <label for="n_estimators">Número de árboles (n_estimators)</label>
                        <input type="number" class="form-control" id="n_estimators" name="n_estimators" placeholder="Ej: 100" required value="100">
                    </div>
                </div>

                <div class="form-row mb-4">
                    <div class="form-group col-md-6">
                        <label for="max_depth">Profundidad máxima (max_depth)</label>
                        <input type="number" class="form-control" id="max_depth" name="max_depth" placeholder="Ej: 6" required value="6">
                    </div>

                    <div class="form-group col-md-6">
                        <label for="subsample">Submuestreo (subsample)</label>
                        <input type="number" step="0.1" min="0" max="1" class="form-control" id="subsample" name="subsample" placeholder="Ej: 0.8" required value="0.8">
                    </div>
                </div>

                <div class="form-group mb-4 d-none">
                    <label for="dataset">Conjunto de datos</label>
                    <select class="form-control" id="dataset" name="dataset">
                        <option value="dataset1.csv">dataset1.csv</option>
                        <option value="dataset2.csv">dataset2.csv</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Entrenar Modelo</button>
            </form>
        </div>
    </div>

    <!-- Selección de modelo -->
    <div class="card mb-4">
        <div class="card-header">
            Seleccionar Modelo Existente
        </div>
        <div class="card-body">
            <div class="form-group mb-4">
                <label for="modeloSeleccionado">Modelos Entrenados</label>
                <select class="form-control" id="modeloSeleccionado">
                    <?php
                    foreach ($data["modelos"] as $modelo) {
                        // agregar la opcion de activo si modelo_activo es 1
                        $activo = $modelo['modelo_activo'] ? ' (Modelo Actual)' : '';
                        echo '<option value="' . $modelo['id_modelo'] . '">' . $modelo['nombre_modelo'] . $activo . '</option>';
                    }
                    ?>
                </select>
            </div>
            <button onclick="usarModelo()" class="btn btn-success">Usar este Modelo</button>
        </div>
    </div>

    <!-- Historial de modelos (opcional) -->
    <div class="card">
        <div class="card-header">
            Historial de Modelos Entrenados
        </div>
        <div class="card-body">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Modelo</th>
                        <th>Detalles</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    foreach ($data["modelos"] as $modelo) {
                        echo '<tr>';
                        echo '<td>' . $modelo['fecha_entrenamiento'] . '</td>';
                        echo '<td>' . $modelo['nombre_modelo'] . '</td>';
                        echo '<td>';
                        echo '<button class="btn btn-info btn-sm" onclick="verDetalles(\'' . $modelo['id_modelo'] . '\')">Ver Detalles</button>';
                        echo '<button class="btn btn-danger btn-sm d-none" onclick="eliminarModelo(\'' . $modelo['id_modelo'] . '\')">Eliminar</button>';
                        echo '</td>';
                        echo '</tr>';
                    }
                    ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php footer_web('Template.FooterDashboard', $data); ?>