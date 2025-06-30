$(document).ready(function () {
  let cuestionarioAEliminar = null;

  // Inicializar DataTable con server-side processing
  const table = $("#cuestionariosTable").DataTable({
    processing: true,
    serverSide: true,
    ajax: {
      url: "/admin/cuestionarios", // Cambia esta URL por tu endpoint
      type: "POST",
      data: function (d) {
        // Aquí puedes agregar parámetros adicionales si es necesario
        return d;
      },
      error: function (xhr, error, code) {
        console.error("Error al cargar datos:", error);
        alert("Error al cargar los datos del servidor");
      },
    },
    columns: [
      {
        data: "num_cuestionario",
        orderable: true,
        searchable: true,
      },
      {
        data: "nombre_completo",
        orderable: true,
        searchable: true,
      },
      {
        data: "fecha_cuestionario",
        orderable: true,
        searchable: false,
        render: function (data, type, row) {
          if (type === "display" || type === "type") {
            // Formatear fecha si es necesario
            const fecha = new Date(data);
            return fecha.toLocaleDateString("es-ES");
          }
          return data;
        },
      },
      {
        data: null,
        orderable: false,
        searchable: false,
        render: function (data, type, row) {
          return `
          <div class="btn-group" role="group">
              <button type="button" class="btn btn-info btn-sm" onclick="visualizarCuestionario('${row.num_cuestionario}')" title="Visualizar">
                  <i class="bx bx-window-alt"></i>
              </button>
              <button type="button" class="btn btn-danger btn-sm" onclick="confirmarEliminar(${row.id}, '${row.num_cuestionario}')" title="Eliminar">
                  <i class="bx bxs-trash"></i>
              </button>
          </div>`;
        },
      },
    ],
    order: [[2, "desc"]], // Ordenar por fecha descendente por defecto
    pageLength: 25,
    lengthMenu: [
      [10, 25, 50, 100],
      [10, 25, 50, 100],
    ],
    language: {
      url: "/js/dataTable.Spanish.json",
    },
    responsive: true,
    autoWidth: false,
  });

  // Función para visualizar cuestionario
  window.visualizarCuestionario = function (id) {
    // $("#modalContent").html(
    //   '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Cargando...</div>'
    // );
    // $("#visualizarModal").modal("show");

    // $.ajax({
    //   url: `/admin/cuestionarios/search/${id}`, // Cambia por tu endpoint
    //   method: "GET",
    //   success: function (response) {
    //     console.log(response);

    //     $("#modalContent").html(response);
    //   },
    //   error: function () {
    //     $("#modalContent").html(
    //       '<div class="alert alert-danger">Error al cargar el cuestionario</div>'
    //     );
    //   },
    // });

    // abre una nueva pestaña en el navegador
    window.open(`/admin/cuestionarios/search/${id}`, '_blank');
  };

  // Función para confirmar eliminación
  window.confirmarEliminar = function (id, numCuestionario) {
    cuestionarioAEliminar = id;
    $("#eliminarModalLabel").text(`Eliminar Cuestionario ${numCuestionario}`);
    $("#eliminarModal").modal("show");
  };

  // Confirmar eliminación
  $("#confirmarEliminar").click(function () {
    if (cuestionarioAEliminar) {
      $.ajax({
        url: `api/eliminar-cuestionario.php`, // Cambia por tu endpoint
        method: "POST",
        data: { id: cuestionarioAEliminar },
        success: function (response) {
          $("#eliminarModal").modal("hide");
          table.ajax.reload(); // Recargar la tabla

          // Mostrar mensaje de éxito
          const alert = $(`
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    Cuestionario eliminado correctamente
                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                            `);
          $(".card-body").prepend(alert);

          // Auto-ocultar alerta después de 3 segundos
          setTimeout(() => {
            alert.alert("close");
          }, 3000);
        },
        error: function () {
          $("#eliminarModal").modal("hide");
          alert("Error al eliminar el cuestionario");
        },
      });
    }
    cuestionarioAEliminar = null;
  });

  // Limpiar variable al cerrar modal
  $("#eliminarModal").on("hidden.bs.modal", function () {
    cuestionarioAEliminar = null;
  });
});
