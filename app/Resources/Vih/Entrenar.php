<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="container mt-4">
    <h2 class="mb-4">Importar datos para entrenamiento</h2>
    <div class="card">
        <div class="card-body">
            <form id="form-importar-datos" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="archivoDatos">Seleccionar archivo CSV</label>
                    <input type="file" class="form-control-file" id="archivoDatos" name="archivoDatos" accept=".csv" required>
                </div>
                <button type="submit" class="btn btn-primary">Importar Datos</button>
            </form>
        </div>
    </div>
</div>
<div class="container mt-4">
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
                        <input type="number" step="0.01" min="0" max="1" class="form-control" id="learning_rate" name="learning_rate" placeholder="Ej: 0.1" required>
                    </div>

                    <div class="form-group col-md-6">
                        <label for="n_estimators">Número de árboles (n_estimators)</label>
                        <input type="number" class="form-control" id="n_estimators" name="n_estimators" placeholder="Ej: 100" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="max_depth">Profundidad máxima (max_depth)</label>
                        <input type="number" class="form-control" id="max_depth" name="max_depth" placeholder="Ej: 6" required>
                    </div>

                    <div class="form-group col-md-6">
                        <label for="subsample">Submuestreo (subsample)</label>
                        <input type="number" step="0.1" min="0" max="1" class="form-control" id="subsample" name="subsample" placeholder="Ej: 0.8">
                    </div>
                </div>

                <div class="form-group">
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
            <div class="form-group">
                <label for="modeloSeleccionado">Modelos Entrenados</label>
                <select class="form-control" id="modeloSeleccionado">
                    <option value="modelo_20250625.pkl">modelo_20250625.pkl</option>
                    <option value="modelo_v1_mejorado.pkl">modelo_v1_mejorado.pkl</option>
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
                    <tr>
                        <td>2023-06-25</td>
                        <td>modelo_20230625.pkl</td>
                        <td>
                            <button class="btn btn-info btn-sm" onclick="verDetalles('modelo_20230625.pkl')">Ver Detalles</button>
                            <button class="btn btn-danger btn-sm" onclick="eliminarModelo('modelo_20230625.pkl')">Eliminar</button>
                        </td>
                    </tr>
                    <tr>
                        <td>2023-06-26</td>
                        <td>modelo_20230626.pkl</td>
                        <td>
                            <button class="btn btn-info btn-sm" onclick="verDetalles('modelo_20230626.pkl')">Ver Detalles</button>
                            <button class="btn btn-danger btn-sm" onclick="eliminarModelo('modelo_20230626.pkl')">Eliminar</button>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php footer_web('Template.FooterDashboard', $data); ?>