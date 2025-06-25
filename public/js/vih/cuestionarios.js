// Función para manejar el envío del formulario
document
  .getElementById("formularioVIH")
  .addEventListener("submit", async function (e) {
    e.preventDefault();

    // Validación básica
    if (!validarFormulario()) {
      return;
    }

    // Obtener datos del formulario
    const datosFormulario = obtenerDatosFormulario();

    // Mostrar datos en consola para debugging
    console.log("Datos del formulario:", datosFormulario);

    // Confirmar envío
    const confirmacion = await Swal.fire({
      title: "¿Confirmar envío?",
      text: "¿Está seguro de que desea guardar esta información?",
      icon: "question",
      showCancelButton: true,
      confirmButtonColor: "#3085d6",
      cancelButtonColor: "#d33",
      confirmButtonText: "Sí, guardar",
      cancelButtonText: "Cancelar",
    });

    if (confirmacion.isConfirmed) {
      // Enviar formulario
      await enviarFormulario(datosFormulario);
    }
  });

// Función para enviar datos al servidor
async function enviarFormulario(datos) {
  try {
    // Mostrar loading
    Swal.fire({
      title: "Guardando información...",
      html: "Por favor espere mientras se procesa la información",
      allowOutsideClick: false,
      allowEscapeKey: false,
      showConfirmButton: false,
      didOpen: () => {
        Swal.showLoading();
      },
    });

    const response = await fetch("/admin/cuestionarios/save", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        // Agregar token CSRF si es necesario
        "X-CSRF-TOKEN":
          document
            .querySelector('meta[name="csrf-token"]')
            ?.getAttribute("content") || "",
        // Agregar headers de autenticación si es necesario
        // 'Authorization': 'Bearer ' + token
      },
      body: JSON.stringify(datos),
    });

    // Verificar si la respuesta es exitosa
    if (!response.ok) {
      throw new Error(
        `Error HTTP: ${response.status} - ${response.statusText}`
      );
    }

    const resultado = await response.json();

    // Cerrar loading
    Swal.close();

    // Manejar respuesta exitosa
    if (resultado.success || resultado.status === "success") {
      Swal.fire({
        title: "¡Éxito!",
        text:
          resultado.message || "La información ha sido guardada correctamente",
        icon: "success",
        confirmButtonText: "OK",
        timer: 3000,
        timerProgressBar: true,
      }).then(() => {
        // Opcional: limpiar formulario o redirigir
        // document.getElementById('formularioVIH').reset();
        // window.location.href = '/admin/cuestionarios';
      });

      // Mostrar modal de confirmación si existe
      if (typeof $ !== "undefined" && $("#confirmacionModal").length) {
        $("#confirmacionModal").modal("show");
      }
    } else {
      // Manejar errores del servidor
      throw new Error(resultado.message || "Error desconocido del servidor");
    }
  } catch (error) {
    // Cerrar loading si está activo
    Swal.close();

    console.error("Error al enviar formulario:", error);

    // Determinar tipo de error
    let mensajeError = "Ocurrió un error al guardar la información. ";

    if (error.name === "TypeError" && error.message.includes("fetch")) {
      mensajeError += "Verifique su conexión a internet.";
    } else if (error.message.includes("HTTP: 422")) {
      mensajeError += "Los datos enviados no son válidos.";
    } else if (error.message.includes("HTTP: 401")) {
      mensajeError += "No tiene autorización para realizar esta acción.";
    } else if (error.message.includes("HTTP: 500")) {
      mensajeError += "Error interno del servidor.";
    } else {
      mensajeError += error.message;
    }

    Swal.fire({
      title: "Error",
      text: mensajeError,
      icon: "error",
      confirmButtonText: "OK",
      footer:
        "<small>Si el problema persiste, contacte al administrador</small>",
    });
  }
}

// Función de validación
function validarFormulario() {
  let valido = true;
  let mensajeError = "";

  // 1. Validar Identificación Geográfica
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

  // Validar si seleccionó "Otro" que especifique
  if (establecimiento && establecimiento.value === "otro") {
    const otroEspecifique = document
      .getElementById("otro_especifique")
      .value.trim();
    if (!otroEspecifique) {
      mensajeError += "- Debe especificar el nombre del establecimiento\n";
      valido = false;
    }
  }

  // 2. Validar Datos Sociodemográficos
  const edad = document.getElementById("edad").value;
  if (!edad || edad < 1 || edad > 120) {
    mensajeError += "- Debe ingresar una edad válida (1-120 años)\n";
    valido = false;
  }

  const sexo = document.querySelector('input[name="sexo"]:checked');
  if (!sexo) {
    mensajeError += "- Debe seleccionar el sexo\n";
    valido = false;
  }

  const estadoCivil = document.querySelector(
    'select[name="estado_civil"]'
  ).value;
  if (!estadoCivil) {
    mensajeError += "- Debe seleccionar el estado civil\n";
    valido = false;
  }

  const nivelEducativo = document.querySelector(
    'select[name="nivel_educativo"]'
  ).value;
  if (!nivelEducativo) {
    mensajeError += "- Debe seleccionar el nivel educativo\n";
    valido = false;
  }

  const ocupacion = document.getElementById("ocupacion").value.trim();
  if (!ocupacion) {
    mensajeError += "- Debe ingresar la ocupación actual\n";
    valido = false;
  }

  const residencia = document.getElementById("residencia").value.trim();
  if (!residencia) {
    mensajeError += "- Debe ingresar el lugar de residencia\n";
    valido = false;
  }

  // 3. Validar Comportamientos y Factores de Riesgo
  const preservativosAntes = document.querySelector(
    'input[name="preservativos_antes"]:checked'
  );
  if (!preservativosAntes) {
    mensajeError +=
      "- Debe indicar si usaba preservativos antes del diagnóstico\n";
    valido = false;
  }

  const relacionesSinProteccion = document.querySelector(
    'input[name="relaciones_sin_proteccion"]:checked'
  );
  if (!relacionesSinProteccion) {
    mensajeError +=
      "- Debe indicar si ha tenido relaciones sin protección desde el diagnóstico\n";
    valido = false;
  }

  const parejasSexuales = document.getElementById("parejas_sexuales").value;
  if (parejasSexuales === "" || parejasSexuales < 0) {
    mensajeError +=
      "- Debe ingresar el número de parejas sexuales (mínimo 0)\n";
    valido = false;
  }

  const mismoSexo = document.querySelector('input[name="mismo_sexo"]:checked');
  if (!mismoSexo) {
    mensajeError +=
      "- Debe indicar si ha tenido relaciones con personas del mismo sexo\n";
    valido = false;
  }

  const drogasInyectables = document.querySelector(
    'input[name="drogas_inyectables"]:checked'
  );
  if (!drogasInyectables) {
    mensajeError += "- Debe indicar si ha usado drogas inyectables\n";
    valido = false;
  }

  const transfusiones = document.querySelector(
    'input[name="transfusiones"]:checked'
  );
  if (!transfusiones) {
    mensajeError +=
      "- Debe indicar si recibió transfusiones en los últimos 5 años\n";
    valido = false;
  }

  const antecedentesIts = document.querySelector(
    'input[name="antecedentes_its"]:checked'
  );
  if (!antecedentesIts) {
    mensajeError += "- Debe indicar si tiene antecedentes de ITS\n";
    valido = false;
  }

  // Validar especificación de ITS si respondió "Sí"
  if (antecedentesIts && antecedentesIts.value === "si") {
    const itsEspecificar = document
      .getElementById("its_especificar")
      .value.trim();
    if (!itsEspecificar) {
      mensajeError += "- Debe especificar qué tipo de ITS ha tenido\n";
      valido = false;
    }
  }

  // 4. Validar Información Clínica Relevante
  const fechaDiagnostico = document.getElementById("fecha_diagnostico").value;
  if (!fechaDiagnostico) {
    mensajeError += "- Debe ingresar la fecha de diagnóstico de VIH\n";
    valido = false;
  } else {
    // Validar que la fecha no sea futura
    const fechaIngresada = new Date(fechaDiagnostico);
    const fechaActual = new Date();
    if (fechaIngresada > fechaActual) {
      mensajeError +=
        "- La fecha de diagnóstico no puede ser posterior a la fecha actual\n";
      valido = false;
    }
  }

  const tipoPrueba = document.querySelector('select[name="tipo_prueba"]').value;
  if (!tipoPrueba) {
    mensajeError += "- Debe seleccionar el tipo de prueba de diagnóstico\n";
    valido = false;
  }

  // Validar especificación si seleccionó "Otro" tipo de prueba
  if (tipoPrueba === "otro") {
    const otroPrueba = document.getElementById("otro_prueba").value.trim();
    if (!otroPrueba) {
      mensajeError += "- Debe especificar el tipo de prueba\n";
      valido = false;
    }
  }

  const tar = document.querySelector('input[name="tar"]:checked');
  if (!tar) {
    mensajeError += "- Debe indicar si recibe tratamiento antirretroviral\n";
    valido = false;
  }

  // Validar fecha de inicio TAR si recibe tratamiento
  if (tar && tar.value === "si") {
    const fechaInicioTar = document.getElementById("fecha_inicio_tar").value;
    if (!fechaInicioTar) {
      mensajeError += "- Debe ingresar la fecha de inicio del TAR\n";
      valido = false;
    } else {
      // Validar que la fecha de TAR no sea anterior al diagnóstico
      if (fechaDiagnostico) {
        const fechaTar = new Date(fechaInicioTar);
        const fechaDiag = new Date(fechaDiagnostico);
        if (fechaTar < fechaDiag) {
          mensajeError +=
            "- La fecha de inicio del TAR no puede ser anterior al diagnóstico\n";
          valido = false;
        }
      }
    }
  }

  const cd4 = document.getElementById("cd4").value;
  if (cd4 !== "" && (cd4 < 0 || cd4 > 5000)) {
    mensajeError +=
      "- El conteo de CD4 debe estar entre 0 y 5000 células/mm³\n";
    valido = false;
  }

  const cargaViral = document.getElementById("carga_viral").value;
  if (cargaViral !== "" && cargaViral < 0) {
    mensajeError += "- La carga viral no puede ser negativa\n";
    valido = false;
  }

  const itsActual = document.querySelector('input[name="its_actual"]:checked');
  if (!itsActual) {
    mensajeError += "- Debe indicar si presenta alguna ITS actualmente\n";
    valido = false;
  }

  // 5. Validar Riesgo de Transmisión Actual
  const parejaActiva = document.querySelector(
    'input[name="pareja_activa"]:checked'
  );
  if (!parejaActiva) {
    mensajeError +=
      "- Debe indicar si tiene pareja sexual activa actualmente\n";
    valido = false;
  }

  const informaParejas = document.querySelector(
    'input[name="informa_parejas"]:checked'
  );
  if (!informaParejas) {
    mensajeError +=
      "- Debe indicar si informa a sus parejas sobre su estado de VIH\n";
    valido = false;
  }

  const preservativoActual = document.querySelector(
    'input[name="preservativo_actual"]:checked'
  );
  if (!preservativoActual) {
    mensajeError += "- Debe indicar si utiliza preservativo actualmente\n";
    valido = false;
  }

  const parejaPrueba = document.querySelector(
    'input[name="pareja_prueba"]:checked'
  );
  if (!parejaPrueba) {
    mensajeError +=
      "- Debe indicar si su(s) pareja(s) se ha(n) realizado la prueba de VIH\n";
    valido = false;
  }

  // Mostrar errores si los hay
  if (!valido) {
    Swal.fire({
      title: "Formulario incompleto",
      html: `<div style="white-space: pre-line; text-align: left;">Por favor complete los siguientes campos obligatorios:\n\n${mensajeError}</div>`,
      icon: "error",
      confirmButtonText: "OK",
      width: "600px",
    });
  }

  return valido;
}
// Función para limpiar el formulario
function limpiarFormulario() {
  Swal.fire({
    title: "¿Está seguro?",
    text: "Se perderán todos los datos ingresados",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#3085d6",
    cancelButtonColor: "#d33",
    confirmButtonText: "Sí, limpiar",
    cancelButtonText: "Cancelar",
  }).then((result) => {
    if (result.isConfirmed) {
      document.getElementById("formularioVIH").reset();
      Swal.fire(
        "Limpiado",
        "El formulario ha sido limpiado exitosamente",
        "success"
      );
    }
  });
}

// Manejar la opción "Otro establecimiento"
document.addEventListener("DOMContentLoaded", function () {
  const establecimientoRadios = document.querySelectorAll(
    'input[name="establecimiento"]'
  );
  const otroInput = document.getElementById("otro_especifique");

  establecimientoRadios.forEach(function (radio) {
    radio.addEventListener("change", function () {
      if (this.value === "otro") {
        // Mostrar, habilitar y hacer requerido el campo
        otroInput.style.display = "block";
        otroInput.disabled = false;
        otroInput.required = true;
        otroInput.focus(); // Enfocar automáticamente el campo
      } else {
        // Ocultar, deshabilitar y limpiar el campo
        otroInput.style.display = "none";
        otroInput.disabled = true;
        otroInput.required = false;
        otroInput.value = "";
      }
    });
  });
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
  const formData = new FormData(document.getElementById("formularioVIH"));
  const datos = {};

  // Convertir FormData a objeto
  for (let [key, value] of formData.entries()) {
    datos[key] = value;
  }

  // Agregar campos que no se capturan automáticamente con FormData
  // (como radio buttons no seleccionados)

  // Verificar campos de radio/checkbox específicos
  const zona = document.querySelector('input[name="zona"]:checked');
  datos.zona = zona ? zona.value : null;

  const establecimiento = document.querySelector(
    'input[name="establecimiento"]:checked'
  );
  datos.establecimiento = establecimiento ? establecimiento.value : null;

  const sexo = document.querySelector('input[name="sexo"]:checked');
  datos.sexo = sexo ? sexo.value : null;

  const preservativosAntes = document.querySelector(
    'input[name="preservativos_antes"]:checked'
  );
  datos.preservativos_antes = preservativosAntes
    ? preservativosAntes.value
    : null;

  const relacionesSinProteccion = document.querySelector(
    'input[name="relaciones_sin_proteccion"]:checked'
  );
  datos.relaciones_sin_proteccion = relacionesSinProteccion
    ? relacionesSinProteccion.value
    : null;

  const mismoSexo = document.querySelector('input[name="mismo_sexo"]:checked');
  datos.mismo_sexo = mismoSexo ? mismoSexo.value : null;

  const drogasInyectables = document.querySelector(
    'input[name="drogas_inyectables"]:checked'
  );
  datos.drogas_inyectables = drogasInyectables ? drogasInyectables.value : null;

  const transfusiones = document.querySelector(
    'input[name="transfusiones"]:checked'
  );
  datos.transfusiones = transfusiones ? transfusiones.value : null;

  const antecedentesIts = document.querySelector(
    'input[name="antecedentes_its"]:checked'
  );
  datos.antecedentes_its = antecedentesIts ? antecedentesIts.value : null;

  const tar = document.querySelector('input[name="tar"]:checked');
  datos.tar = tar ? tar.value : null;

  const itsActual = document.querySelector('input[name="its_actual"]:checked');
  datos.its_actual = itsActual ? itsActual.value : null;

  const parejaActiva = document.querySelector(
    'input[name="pareja_activa"]:checked'
  );
  datos.pareja_activa = parejaActiva ? parejaActiva.value : null;

  const informaParejas = document.querySelector(
    'input[name="informa_parejas"]:checked'
  );
  datos.informa_parejas = informaParejas ? informaParejas.value : null;

  const preservativoActual = document.querySelector(
    'input[name="preservativo_actual"]:checked'
  );
  datos.preservativo_actual = preservativoActual
    ? preservativoActual.value
    : null;

  const parejaPrueba = document.querySelector(
    'input[name="pareja_prueba"]:checked'
  );
  datos.pareja_prueba = parejaPrueba ? parejaPrueba.value : null;

  return datos;
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
