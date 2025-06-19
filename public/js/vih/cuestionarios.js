// Función para manejar el envío del formulario
document
  .getElementById("formularioVIH")
  .addEventListener("submit", function (e) {
    e.preventDefault();

    // Validación básica
    if (!validarFormulario()) {
      return;
    }

    // Simular envío de datos
    setTimeout(function () {
      $("#confirmacionModal").modal("show");
    }, 500);
  });

// Función de validación
function validarFormulario() {
  let valido = true;
  let mensajeError = "";

  // Validar campos requeridos
  const distrito = document.querySelector('select[name="distrito"]').value;
  if (!distrito) {
    mensajeError += "- Debe seleccionar un distrito\n";
    valido = false;
  }

  const zona = document.querySelector('input[name="zona"]:checked');
  if (!zona) {
    mensajeError += "- Debe seleccionar una zona (Urbana/Rural)\n";
    valido = false;
  }

  const establecimiento = document.querySelector(
    'input[name="establecimiento"]:checked'
  );
  if (!establecimiento) {
    mensajeError += "- Debe seleccionar un establecimiento de salud\n";
    valido = false;
  }

  if (!valido) {
    alert(
      "Por favor complete los siguientes campos obligatorios:\n\n" +
        mensajeError
    );
  }

  return valido;
}

// Función para limpiar el formulario
function limpiarFormulario() {
  if (
    confirm(
      "¿Está seguro que desea limpiar todo el formulario? Esta acción no se puede deshacer."
    )
  ) {
    document.getElementById("formularioVIH").reset();

    // Mostrar mensaje de confirmación
    const toast = document.createElement("div");
    toast.className =
      "alert alert-info alert-dismissible fade show position-fixed";
    toast.style.cssText =
      "top: 20px; right: 20px; z-index: 9999; min-width: 300px;";
    toast.innerHTML = `
                    <i class="fas fa-info-circle"></i>
                    <strong>Formulario limpiado</strong> - Todos los campos han sido restaurados.
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                `;
    document.body.appendChild(toast);

    // Auto-remover el toast después de 3 segundos
    setTimeout(function () {
      if (toast.parentNode) {
        toast.parentNode.removeChild(toast);
      }
    }, 3000);
  }
}

// Manejar la opción "Otro establecimiento"
document
  .getElementById("otro_establecimiento")
  .addEventListener("change", function () {
    const otroInput = document.getElementById("otro_especifique");
    if (this.checked) {
      otroInput.style.display = "block";
      otroInput.required = true;
      otroInput.focus();
    } else {
      otroInput.style.display = "none";
      otroInput.required = false;
      otroInput.value = "";
    }
  });

// Manejar el tipo de prueba "Otro"
document
  .querySelector('select[name="tipo_prueba"]')
  .addEventListener("change", function () {
    const otroInput = document.getElementById("otro_prueba");
    if (this.value === "otro") {
      otroInput.style.display = "block";
      otroInput.required = true;
      otroInput.focus();
    } else {
      otroInput.style.display = "none";
      otroInput.required = false;
      otroInput.value = "";
    }
  });

// Agregar efectos de hover a las secciones
document.querySelectorAll(".custom-checkbox").forEach(function (checkbox) {
  checkbox.addEventListener("mouseenter", function () {
    this.style.transform = "translateY(-2px)";
    this.style.boxShadow = "0 5px 15px rgba(0,0,0,0.1)";
  });

  checkbox.addEventListener("mouseleave", function () {
    this.style.transform = "translateY(0)";
    this.style.boxShadow = "none";
  });
});

// Inicializar tooltips si se necesitan
$(function () {
  $('[data-toggle="tooltip"]').tooltip();
});

// Guardar progreso automáticamente en memoria (no localStorage)
let formData = {};

function guardarProgreso() {
  const form = document.getElementById("formularioVIH");
  const formDataObj = new FormData(form);
  formData = {};

  for (let [key, value] of formDataObj.entries()) {
    formData[key] = value;
  }

  console.log("Progreso guardado en memoria:", formData);
}

// Guardar progreso cada vez que se modifica un campo
document
  .getElementById("formularioVIH")
  .addEventListener("change", guardarProgreso);
document
  .getElementById("formularioVIH")
  .addEventListener("input", guardarProgreso);

// Función para obtener los datos del formulario
function obtenerDatosFormulario() {
  return formData;
}

// Animación de carga suave
document.addEventListener("DOMContentLoaded", function () {
  const formContainer = document.querySelector(".form-container");
  formContainer.style.opacity = "0";
  formContainer.style.transform = "translateY(30px)";

  setTimeout(function () {
    formContainer.style.transition = "all 0.6s ease";
    formContainer.style.opacity = "1";
    formContainer.style.transform = "translateY(0)";
  }, 100);
});
