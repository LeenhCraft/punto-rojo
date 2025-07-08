document.getElementById("btnPredecir").addEventListener("click", function () {
  const meses_futuro = document.getElementById("selectedMonths").value;
  // Confirmación previa con SweetAlert
  Swal.fire({
    title: "¿Estás seguro?",
    text: "¿Deseas ejecutar la predicción?",
    icon: "question",
    showCancelButton: true,
    confirmButtonColor: "#3085d6",
    cancelButtonColor: "#d33",
    confirmButtonText: "Sí, predecir",
    cancelButtonText: "Cancelar",
  }).then((result) => {
    if (result.isConfirmed) {
      // Mostrar loading
      Swal.fire({
        title: "Procesando...",
        text: "Ejecutando predicción",
        allowOutsideClick: false,
        didOpen: () => {
          Swal.showLoading();
        },
      });

      // Realizar petición POST
      fetch("/admin/predecir", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          // Aquí puedes agregar los datos que necesites enviar
          meses_futuro: meses_futuro,
        }),
      })
        .then((response) => {
          if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
          }
          return response.json();
        })
        .then((data) => {
          if (data.success) {
            // Cerrar loading y mostrar resultado exitoso
            Swal.fire({
              title: "¡Éxito!",
              text: "Predicción ejecutada correctamente",
              icon: "success",
              confirmButtonText: "OK",
            });
          } else {
            // Cerrar loading y mostrar error
            Swal.fire({
              title: "Error",
              text: "Hubo un problema al ejecutar la predicción: " + data.error,
              icon: "error",
              confirmButtonText: "OK",
            });
          }
          try {
            new Audio("/notificacion.mp3").play();
          } catch (audioError) {
            console.warn("No se pudo reproducir el audio:", audioError);
          }

          // Aquí puedes manejar la respuesta exitosa
          console.log("Respuesta:", data);
        })
        .catch((error) => {
          try {
            new Audio("/notificacion.mp3").play();
          } catch (audioError) {
            console.warn("No se pudo reproducir el audio:", audioError);
          }

          // Cerrar loading y mostrar error
          Swal.fire({
            title: "Error",
            text:
              "Hubo un problema al ejecutar la predicción: " + error.message,
            icon: "error",
            confirmButtonText: "OK",
          });

          console.error("Error:", error);
        });
    }
  });
});
