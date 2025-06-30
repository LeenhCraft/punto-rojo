<?php header_web('Template.HeaderDashboard', $data); ?>
<div class="card">
    <div class="card-header">
        <h3 class="card-title">Lista de Cuestionarios</h3>
    </div>
    <div class="card-body">
        <table id="cuestionariosTable" class="table table-striped table-bordered" style="width:100%">
            <thead>
                <tr>
                    <th>N° Cuestionario</th>
                    <th>Nombre Completo</th>
                    <th>Fecha</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <!-- Los datos se cargan via AJAX -->
            </tbody>
        </table>
    </div>
</div>

<!-- Modal para visualizar cuestionario -->
<div class="modal fade" id="visualizarModal" tabindex="-1" role="dialog" aria-labelledby="visualizarModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="visualizarModalLabel">Cuestionario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                </button>
            </div>
            <div class="modal-body" id="modalContent">
                <!-- Contenido del cuestionario se carga aquí -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de confirmación para eliminar -->
<div class="modal fade" id="eliminarModal" tabindex="-1" role="dialog" aria-labelledby="eliminarModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eliminarModalLabel">Confirmar Eliminación</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                ¿Está seguro que desea eliminar este cuestionario? Esta acción no se puede deshacer.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger" id="confirmarEliminar">Eliminar</button>
            </div>
        </div>
    </div>
</div>
<?php footer_web('Template.FooterDashboard', $data); ?>