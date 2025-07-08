// form-preparar-datos
document
  .getElementById("form-preparar-datos")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    // Mostrar confirmación avanzada
    Swal.fire({
      title: "Preparación de Dataset",
      html: `
        <div style="text-align: left; margin: 20px 0;">
          <p><strong>¿Iniciar preparación de datos?</strong></p>
          <ul style="margin: 10px 0; padding-left: 20px;">
            <li>Se procesarán los cuestionarios VIH</li>
            <li>Se crearán features temporales</li>
            <li>Se agregarán datos por distrito/establecimiento</li>
            <li>Se generará archivo CSV para entrenamiento</li>
            <li>Duración estimada: 1-3 minutos</li>
          </ul>
          <p style="color: #666; font-size: 0.9em;">
            <strong>Nota:</strong> Este proceso es necesario antes del entrenamiento.
          </p>
        </div>
      `,
      icon: "info",
      showCancelButton: true,
      confirmButtonColor: "#17a2b8",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Preparar datos",
      cancelButtonText: "Cancelar",
      reverseButtons: true,
      allowOutsideClick: false,
      allowEscapeKey: true,
      customClass: {
        popup: "swal-wide",
      },
    }).then((result) => {
      if (result.isConfirmed) {
        // Mostrar loading con progreso
        Swal.fire({
          title: "Preparando dataset...",
          html: `
            <div style="margin: 20px 0;">
              <div style="margin-bottom: 15px;">
                <div class="spinner-border text-info" role="status">
                  <span class="sr-only">Procesando...</span>
                </div>
              </div>
              <p>Extrayendo y procesando datos de cuestionarios VIH</p>
              <p style="font-size: 0.9em; color: #666;">
                Creando features para el modelo de machine learning...
              </p>
            </div>
          `,
          allowOutsideClick: false,
          allowEscapeKey: false,
          showConfirmButton: false,
          didOpen: () => {
            Swal.showLoading();
          },
        });

        var formData = new FormData(this);

        fetch("/admin/entrenamiento/preparar", {
          method: "POST",
          body: formData,
        })
          .then((response) => response.json())
          .then((data) => {
            console.table(data);

            if (data.success) {
              Swal.fire({
                title: "Dataset preparado!",
                html: `
                  <div style="text-align: left; margin: 15px 0;">
                    <p><strong>Datos procesados exitosamente</strong></p>
                    ${
                      data.file_size_kb
                        ? `
                      <div style="background: #d1ecf1; padding: 15px; border-radius: 8px; margin: 10px 0;">
                        <h6>Información del dataset:</h6>
                        <ul style="margin: 5px 0; padding-left: 20px; font-size: 0.9em;">
                          <li>Archivo: ${
                            data.file_path
                              ? data.file_path.split("/").pop()
                              : "dataset.csv"
                          }</li>
                          <li>Tamaño: ${data.file_size_kb} KB</li>
                          <li>Generado: ${new Date(
                            data.timestamp
                          ).toLocaleString()}</li>
                        </ul>
                      </div>
                    `
                        : ""
                    }
                    <p style="color: #17a2b8; font-weight: bold;">
                      ${
                        data.message ||
                        "Los datos están listos para el entrenamiento del modelo"
                      }
                    </p>
                    <div style="background: #d4edda; padding: 10px; border-radius: 6px; margin-top: 10px;">
                      <small style="color: #155724;">
                        <strong>Siguiente paso:</strong> Ahora puedes entrenar el modelo XGBoost
                      </small>
                    </div>
                  </div>
                `,
                icon: "success",
                confirmButtonText: "Entrenar modelo",
                confirmButtonColor: "#28a745",
                showCancelButton: true,
                cancelButtonText: "Cerrar",
                cancelButtonColor: "#6c757d",
                timer: 8000,
                timerProgressBar: true,
                showCloseButton: true,
              }).then((nextResult) => {
                if (nextResult.isConfirmed) {
                  // Redirigir al entrenamiento o activar el formulario
                  const trainForm =
                    document.getElementById("form-entrenamiento");
                  if (trainForm) {
                    trainForm.scrollIntoView({ behavior: "smooth" });
                    // Opcional: resaltar el formulario de entrenamiento
                    trainForm.style.border = "2px solid #28a745";
                    setTimeout(() => {
                      trainForm.style.border = "";
                    }, 3000);
                  }
                }
              });
            } else {
              Swal.fire({
                title: "Error en la preparación",
                html: `
                  <div style="text-align: left; margin: 15px 0;">
                    <p><strong>No se pudieron preparar los datos:</strong></p>
                    <div style="background: #f8d7da; padding: 15px; border-radius: 8px; margin: 10px 0; border-left: 4px solid #dc3545;">
                      <p style="margin: 0; color: #721c24;">
                        ${data.message || "Error desconocido en la preparación"}
                      </p>
                    </div>
                    ${
                      data.error_details
                        ? `
                      <details style="margin-top: 10px;">
                        <summary style="cursor: pointer; color: #666;">Ver detalles técnicos</summary>
                        <pre style="background: #f8f9fa; padding: 10px; border-radius: 4px; font-size: 0.8em; margin-top: 5px; overflow-x: auto;">${data.error_details}</pre>
                      </details>
                    `
                        : ""
                    }
                    <div style="background: #fff3cd; padding: 10px; border-radius: 6px; margin-top: 10px;">
                      <small style="color: #856404;">
                        <strong>Sugerencias:</strong><br>
                        • Verifica que existan cuestionarios en la base de datos<br>
                        • Comprueba los permisos de escritura en el servidor<br>
                        • Revisa la configuración de rutas
                      </small>
                    </div>
                  </div>
                `,
                icon: "error",
                confirmButtonText: "Reintentar",
                confirmButtonColor: "#dc3545",
                showCancelButton: true,
                cancelButtonText: "Cerrar",
                cancelButtonColor: "#6c757d",
              }).then((retryResult) => {
                if (retryResult.isConfirmed) {
                  // Reintentar la preparación
                  document
                    .getElementById("form-preparar-datos")
                    .dispatchEvent(new Event("submit"));
                }
              });
            }

            // reproducir audio
            try {
              new Audio("/notificacion.mp3").play();
            } catch (audioError) {
              console.warn("No se pudo reproducir el audio:", audioError);
            }
          })
          .catch((error) => {
            console.error("Error:", error);

            Swal.fire({
              title: "🔌 Error de conexión",
              html: `
                <div style="text-align: left; margin: 15px 0;">
                  <p><strong>No se pudo conectar con el servidor</strong></p>
                  <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin: 10px 0; border-left: 4px solid #ffc107;">
                    <ul style="margin: 0; padding-left: 20px;">
                      <li>Verifica tu conexión a internet</li>
                      <li>Comprueba que el servidor esté funcionando</li>
                      <li>Asegúrate de que el endpoint esté disponible</li>
                      <li>Si el problema persiste, contacta al administrador</li>
                    </ul>
                  </div>
                </div>
              `,
              icon: "error",
              confirmButtonText: "Reintentar",
              confirmButtonColor: "#ffc107",
              showCancelButton: true,
              cancelButtonText: "Cerrar",
              cancelButtonColor: "#6c757d",
            }).then((retryResult) => {
              if (retryResult.isConfirmed) {
                // Reintentar la preparación
                document
                  .getElementById("form-preparar-datos")
                  .dispatchEvent(new Event("submit"));
              }
            });
          });
      }
    });
  });

// form-entrenamiento
document
  .getElementById("form-entrenamiento")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    // Mostrar confirmación avanzada
    Swal.fire({
      title: "Entrenamiento de Modelo IA",
      html: `
        <div style="text-align: left; margin: 20px 0;">
          <p><strong>¿Estás seguro de iniciar el entrenamiento?</strong></p>
          <ul style="margin: 10px 0; padding-left: 20px;">
            <li>Duración estimada: 3-10 minutos</li>
            <li>Se procesarán todos los datos disponibles</li>
            <li>El modelo actual será reemplazado</li>
            <li>Se generarán nuevas predicciones</li>
          </ul>
          <p style="color: #666; font-size: 0.9em;">
            <strong>Nota:</strong> No cierres esta ventana durante el proceso.
          </p>
        </div>
      `,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#28a745",
      cancelButtonColor: "#6c757d",
      confirmButtonText: "Iniciar entrenamiento",
      cancelButtonText: "Cancelar",
      reverseButtons: true,
      allowOutsideClick: false,
      allowEscapeKey: true,
      customClass: {
        popup: "swal-wide",
      },
    }).then((result) => {
      if (result.isConfirmed) {
        // Mostrar loading con progreso
        Swal.fire({
          title: "Entrenando modelo...",
          html: `
            <div style="margin: 20px 0;">
              <div style="margin-bottom: 15px;">
                <div class="spinner-border text-primary" role="status">
                  <span class="sr-only">Cargando...</span>
                </div>
              </div>
              <p>Procesando datos y entrenando algoritmo XGBoost</p>
              <p style="font-size: 0.9em; color: #666;">
                Por favor, mantén esta ventana abierta...
              </p>
            </div>
          `,
          allowOutsideClick: false,
          allowEscapeKey: false,
          showConfirmButton: false,
          didOpen: () => {
            Swal.showLoading();
          },
        });

        var formData = new FormData(this);

        fetch("/admin/entrenamiento", {
          method: "POST",
          body: formData,
        })
          .then((response) => response.json())
          .then((data) => {
            console.log(data);

            if (data.success) {
              Swal.fire({
                title: "¡Entrenamiento completado!",
                html: `
                  <div style="text-align: left; margin: 15px 0;">
                    <p><strong>Modelo entrenado exitosamente</strong></p>
                    ${
                      data.metrics
                        ? `
                      <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 10px 0;">
                        <h6>Métricas del modelo:</h6>
                        <ul style="margin: 5px 0; padding-left: 20px; font-size: 0.9em;">
                          ${
                            data.metrics.test_r2
                              ? `<li>Precisión R²: ${(
                                  data.metrics.test_r2 * 100
                                ).toFixed(2)}%</li>`
                              : ""
                          }
                          ${
                            data.metrics.test_mape
                              ? `<li>Error MAPE: ${data.metrics.test_mape.toFixed(
                                  2
                                )}%</li>`
                              : ""
                          }
                          ${
                            data.training_info?.training_samples
                              ? `<li>Muestras entrenamiento: ${data.training_info.training_samples}</li>`
                              : ""
                          }
                        </ul>
                      </div>
                    `
                        : ""
                    }
                    <p style="color: #28a745; font-weight: bold;">
                      ${
                        data.message ||
                        "El modelo está listo para generar predicciones"
                      }
                    </p>
                  </div>
                `,
                icon: "success",
                confirmButtonText: "Ver resultados",
                confirmButtonColor: "#28a745",
                timer: 8000,
                timerProgressBar: true,
                showCloseButton: true,
              });
            } else {
              Swal.fire({
                title: "Error en el entrenamiento",
                html: `
                  <div style="text-align: left; margin: 15px 0;">
                    <p><strong>No se pudo completar el entrenamiento:</strong></p>
                    <div style="background: #f8d7da; padding: 15px; border-radius: 8px; margin: 10px 0; border-left: 4px solid #dc3545;">
                      <p style="margin: 0; color: #721c24;">
                        ${data.message || "Error desconocido"}
                      </p>
                    </div>
                    ${
                      data.error_details
                        ? `
                      <details style="margin-top: 10px;">
                        <summary style="cursor: pointer; color: #666;">Ver detalles técnicos</summary>
                        <pre style="background: #f8f9fa; padding: 10px; border-radius: 4px; font-size: 0.8em; margin-top: 5px; overflow-x: auto;">${data.error_details}</pre>
                      </details>
                    `
                        : ""
                    }
                  </div>
                `,
                icon: "error",
                confirmButtonText: "Reintentar",
                confirmButtonColor: "#dc3545",
                showCancelButton: true,
                cancelButtonText: "Cerrar",
                cancelButtonColor: "#6c757d",
              }).then((retryResult) => {
                if (retryResult.isConfirmed) {
                  // Reintentar el entrenamiento
                  document
                    .getElementById("form-entrenamiento")
                    .dispatchEvent(new Event("submit"));
                }
              });
            }

            // reproducir audio
            try {
              new Audio("/notificacion.mp3").play();
            } catch (audioError) {
              console.warn("No se pudo reproducir el audio:", audioError);
            }
          })
          .catch((error) => {
            console.error("Error:", error);

            Swal.fire({
              title: "Error de conexión",
              html: `
                <div style="text-align: left; margin: 15px 0;">
                  <p><strong>No se pudo conectar con el servidor</strong></p>
                  <div style="background: #fff3cd; padding: 15px; border-radius: 8px; margin: 10px 0; border-left: 4px solid #ffc107;">
                    <ul style="margin: 0; padding-left: 20px;">
                      <li>Verifica tu conexión a internet</li>
                      <li>Comprueba que el servidor esté funcionando</li>
                      <li>Si el problema persiste, contacta al administrador</li>
                    </ul>
                  </div>
                </div>
              `,
              icon: "error",
              confirmButtonText: "Reintentar",
              confirmButtonColor: "#ffc107",
              showCancelButton: true,
              cancelButtonText: "Cerrar",
              cancelButtonColor: "#6c757d",
            }).then((retryResult) => {
              if (retryResult.isConfirmed) {
                // Reintentar el entrenamiento
                document
                  .getElementById("form-entrenamiento")
                  .dispatchEvent(new Event("submit"));
              }
            });
          });
      }
    });
  });

// usarModelo() enviar el id del select modeloSeleccionado mediante fetch a /admin/entrenamiento/activar
function usarModelo() {
  const modeloSeleccionado = document.getElementById(
    "modeloSeleccionado"
  ).value;

  fetch("/admin/entrenamiento/activar", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ id: modeloSeleccionado }),
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        Swal.fire({
          title: "Modelo activado",
          text: data.message,
          icon: "success",
        });
      } else {
        Swal.fire({
          title: "Error",
          text: data.message,
          icon: "error",
        });
      }
    })
    .catch((error) => {
      console.error("Error:", error);
      Swal.fire({
        title: "Error",
        text: "No se pudo activar el modelo",
        icon: "error",
      });
    });
}
