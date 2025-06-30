// Función para cargar datos del cuestionario VIH
function cargarDatosCuestionario(datos) {
  try {
    // Función auxiliar para formatear fechas
    function formatearFecha(fechaStr, conHora = false) {
      if (!fechaStr) return "No especificada";

      const fecha = new Date(fechaStr);
      const dia = fecha.getDate().toString().padStart(2, "0");
      const mes = (fecha.getMonth() + 1).toString().padStart(2, "0");
      const anio = fecha.getFullYear();

      if (conHora) {
        const horas = fecha.getHours().toString().padStart(2, "0");
        const minutos = fecha.getMinutes().toString().padStart(2, "0");
        return `${dia}/${mes}/${anio} ${horas}:${minutos}`;
      }

      return `${dia}/${mes}/${anio}`;
    }

    // Función auxiliar para formatear texto
    function formatearTexto(texto) {
      if (!texto) return "";
      return texto
        .toLowerCase()
        .split(" ")
        .map((palabra) => palabra.charAt(0).toUpperCase() + palabra.slice(1))
        .join(" ");
    }

    // Función auxiliar para convertir valores booleanos a texto
    function convertirBooleano(valor) {
      return valor === 1 || valor === true ? "Sí" : "No";
    }

    // Función auxiliar para formatear valores de uso
    function formatearUsoPreservativo(valor) {
      const mapeo = {
        Siempre: "Siempre",
        A_veces: "A veces",
        Nunca: "Nunca",
      };
      return mapeo[valor] || valor;
    }

    // Meta información
    document.getElementById("num-cuestionario").textContent =
      datos.num_cuestionario || "";
    document.getElementById("fecha-aplicacion").textContent = formatearFecha(
      datos.fecha_aplicacion,
      true
    );
    document.getElementById("estado").textContent = datos.estado || "";
    document.getElementById("personal").textContent = `ID: ${
      datos.id_personal || ""
    }`;

    // Datos del Paciente
    document.getElementById("nombre-completo").textContent =
      formatearTexto(datos.nombre_completo) || "";
    document.getElementById("tipo-documento").textContent =
      datos.tipo_documento || "";
    document.getElementById("numero-documento").textContent =
      datos.numero_documento || "";
    document.getElementById("fecha-nacimiento").textContent = formatearFecha(
      datos.fecha_nacimiento
    );
    document.getElementById("edad").textContent = `${datos.edad || 0} años`;

    // Estado del paciente
    const estadoPaciente = datos.paciente_activo === 1 ? "Activo" : "Inactivo";
    document.getElementById("paciente-activo").textContent = estadoPaciente;
    document.getElementById("paciente-activo").className = `badge ${
      datos.paciente_activo === 1 ? "badge-success" : "badge-danger"
    }`;

    // Establecimiento de Salud
    document.getElementById("establecimiento").textContent =
      datos.nombre_establecimiento || "";
    document.getElementById("codigo-establecimiento").textContent =
      datos.codigo_establecimiento || "";
    document.getElementById("zona").textContent = datos.zona || "";
    document.getElementById("microred").textContent = datos.microred || "";
    document.getElementById("direccion").textContent = datos.direccion || "";

    // Datos Sociodemográficos
    document.getElementById("sexo").textContent = datos.sexo || "";
    document.getElementById("estado-civil").textContent =
      datos.estado_civil || "";
    document.getElementById("nivel-educativo").textContent =
      datos.nivel_educativo || "";
    document.getElementById("ocupacion").textContent =
      formatearTexto(datos.ocupacion_actual) || "";
    document.getElementById("residencia").textContent =
      formatearTexto(datos.lugar_residencia) || "";

    // Información Clínica
    document.getElementById("fecha-diagnostico").textContent = formatearFecha(
      datos.fecha_diagnostico_vih
    );
    document.getElementById("tipo-prueba").textContent =
      datos.tipo_prueba_diagnostico || "No especificada";

    // TAR
    const recibeTar = convertirBooleano(datos.recibe_tar);
    document.getElementById("recibe-tar").innerHTML = `<span class="badge ${
      datos.recibe_tar === 1 ? "badge-success" : "badge-danger"
    }">${recibeTar}</span>`;

    document.getElementById("cd4").textContent = `${datos.ultimo_cd4 || 0} ${
      datos.unidad_cd4 || "células/μL"
    }`;
    document.getElementById("carga-viral").textContent = `${
      datos.ultima_carga_viral || 0
    } ${datos.unidad_carga_viral || "copias/mL"}`;

    // ITS actual
    const presentaIts = convertirBooleano(datos.presenta_its_actual);
    document.getElementById("its-actual").innerHTML = `<span class="badge ${
      datos.presenta_its_actual === 1 ? "badge-danger" : "badge-success"
    }">${presentaIts}</span>`;

    // Factores de Riesgo
    document.getElementById("preservativos-pre").textContent =
      formatearUsoPreservativo(datos.uso_preservativos_pre_diagnostico);

    const relacionesSinProteccion = convertirBooleano(
      datos.relaciones_sin_proteccion_post_diagnostico
    );
    document.getElementById(
      "relaciones-sin-proteccion"
    ).innerHTML = `<span class="badge ${
      datos.relaciones_sin_proteccion_post_diagnostico === 1
        ? "badge-danger"
        : "badge-success"
    }">${relacionesSinProteccion}</span>`;

    document.getElementById("parejas-anio").textContent =
      datos.numero_parejas_ultimo_anio || 0;

    const relacionesMismoSexo = convertirBooleano(datos.relaciones_mismo_sexo);
    document.getElementById("mismo-sexo").innerHTML = `<span class="badge ${
      datos.relaciones_mismo_sexo === 1 ? "badge-warning" : "badge-success"
    }">${relacionesMismoSexo}</span>`;

    const drogasInyectables = convertirBooleano(datos.uso_drogas_inyectables);
    document.getElementById(
      "drogas-inyectables"
    ).innerHTML = `<span class="badge ${
      datos.uso_drogas_inyectables === 1 ? "badge-danger" : "badge-success"
    }">${drogasInyectables}</span>`;

    const transfusiones = convertirBooleano(
      datos.transfusiones_ultimos_5_anios
    );
    document.getElementById("transfusiones").innerHTML = `<span class="badge ${
      datos.transfusiones_ultimos_5_anios === 1
        ? "badge-warning"
        : "badge-success"
    }">${transfusiones}</span>`;

    const antecedentesIts = convertirBooleano(datos.antecedentes_its);
    document.getElementById(
      "antecedentes-its"
    ).innerHTML = `<span class="badge ${
      datos.antecedentes_its === 1 ? "badge-warning" : "badge-success"
    }">${antecedentesIts}</span>`;

    const relacionesOcasionales = convertirBooleano(
      datos.relaciones_ocasionales_post_diagnostico
    );
    document.getElementById(
      "relaciones-ocasionales"
    ).innerHTML = `<span class="badge ${
      datos.relaciones_ocasionales_post_diagnostico === 1
        ? "badge-danger"
        : "badge-success"
    }">${relacionesOcasionales}</span>`;

    // Riesgo de Transmisión Actual
    const parejaActiva = convertirBooleano(datos.tiene_pareja_activa);
    document.getElementById("pareja-activa").innerHTML = `<span class="badge ${
      datos.tiene_pareja_activa === 1 ? "badge-info" : "badge-secondary"
    }">${parejaActiva}</span>`;

    document.getElementById("informa-vih").textContent =
      datos.informa_estado_vih || "";
    document.getElementById("preservativo-actual").textContent =
      formatearUsoPreservativo(datos.uso_preservativo_actual);
    document.getElementById("pareja-prueba").textContent =
      datos.pareja_prueba_vih || "";

    // Evaluación de Riesgo (función personalizable)
    evaluarRiesgo(datos);

    // Observaciones
    const observaciones =
      datos.observaciones_generales || "Sin observaciones registradas";
    document.getElementById("observaciones").textContent = observaciones;
    document.getElementById("observaciones").className =
      observaciones === "Sin observaciones registradas"
        ? "info-value empty-value"
        : "info-value";

    // Fecha del reporte
    document.getElementById("fecha-reporte").textContent = formatearFecha(
      new Date().toISOString(),
      true
    );

    console.log("Datos cargados exitosamente");
  } catch (error) {
    console.error("Error al cargar los datos:", error);
    alert("Error al cargar los datos del cuestionario");
  }
}

// Función para evaluar el riesgo basado en los datos
function evaluarRiesgo(datos) {
  let puntajeRiesgo = 0;
  let factoresRiesgo = [];

  // Evaluación de factores de riesgo
  if (datos.recibe_tar === 0) {
    puntajeRiesgo += 3;
    factoresRiesgo.push("No recibe TAR");
  }

  if (datos.tiene_pareja_activa === 1) {
    puntajeRiesgo += 2;
    if (datos.informa_estado_vih === "Nunca") {
      puntajeRiesgo += 2;
      factoresRiesgo.push("Pareja desconoce estado VIH");
    }
    if (
      datos.uso_preservativo_actual === "Nunca" ||
      datos.uso_preservativo_actual === "A_veces"
    ) {
      puntajeRiesgo += 2;
      factoresRiesgo.push("Uso inconsistente de preservativo");
    }
  }

  if (datos.relaciones_sin_proteccion_post_diagnostico === 1) {
    puntajeRiesgo += 3;
    factoresRiesgo.push("Relaciones sin protección post-diagnóstico");
  }

  if (datos.relaciones_ocasionales_post_diagnostico === 1) {
    puntajeRiesgo += 2;
    factoresRiesgo.push("Relaciones ocasionales");
  }

  if (datos.presenta_its_actual === 1) {
    puntajeRiesgo += 2;
    factoresRiesgo.push("ITS actual");
  }

  if (datos.numero_parejas_ultimo_anio > 1) {
    puntajeRiesgo += 1;
    factoresRiesgo.push("Múltiples parejas");
  }

  // Determinar nivel de riesgo
  let nivelRiesgo, claseRiesgo, mensaje;

  if (puntajeRiesgo >= 6) {
    nivelRiesgo = "Alto";
    claseRiesgo = "risk-high";
    mensaje =
      "Riesgo Alto - Requiere intervención inmediata y seguimiento estrecho";
  } else if (puntajeRiesgo >= 3) {
    nivelRiesgo = "Medio";
    claseRiesgo = "risk-medium";
    mensaje = "Riesgo Medio - Requiere seguimiento y educación continua";
  } else {
    nivelRiesgo = "Bajo";
    claseRiesgo = "risk-low";
    mensaje = "Riesgo Bajo - Mantener medidas preventivas";
  }

  // Actualizar el DOM
  const elementoRiesgo = document.getElementById("evaluacion-riesgo");
  elementoRiesgo.textContent = mensaje;
  elementoRiesgo.className = `risk-indicator ${claseRiesgo}`;

  // Agregar factores de riesgo identificados (opcional)
  if (factoresRiesgo.length > 0) {
    const factoresHtml = factoresRiesgo
      .map((factor) => `<small class="d-block text-muted">• ${factor}</small>`)
      .join("");
    elementoRiesgo.innerHTML =
      mensaje + '<div class="mt-2">' + factoresHtml + "</div>";
  }
}


// Cargar los datos cuando el DOM esté listo
document.addEventListener("DOMContentLoaded", function () {
  cargarDatosCuestionario(datosEjemplo);
});

// También puedes exportar la función para usarla desde otros scripts
// export { cargarDatosCuestionario };
