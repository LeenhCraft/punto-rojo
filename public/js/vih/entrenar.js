// form-importar-datos
document
  .getElementById("form-importar-datos")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    var formData = new FormData(this);

    fetch("/admin/entrenamiento/importar", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          Swal.fire({
            title: "Importación exitosa",
            text:
              "Los datos se han importado correctamente. Total filas procesadas: " +
              data.data.datos,
            icon: "success",
            confirmButtonText: "OK",
          });
        } else {
          Swal.fire({
            title: "Error al importar datos",
            text: data.message,
            icon: "error",
            confirmButtonText: "OK",
          });
        }
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  });
