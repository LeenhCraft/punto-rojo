// form-importar-datos
document
  .getElementById("form-importar-datos")
  .addEventListener("submit", function (event) {
    event.preventDefault();
    divLoading.css("display", "flex");
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
        divLoading.css("display", "none");
      })
      .catch((error) => {
        divLoading.css("display", "none");
        console.error("Error:", error);
      });
  });

// form-preparar-datos
document
  .getElementById("form-preparar-datos")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    var formData = new FormData(this);

    fetch("/admin/entrenamiento/preparar", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.success) {
          Swal.fire({
            title: "Preparación exitosa",
            text: "Los datos se han preparado correctamente.",
            icon: "success",
            confirmButtonText: "OK",
          });
        } else {
          Swal.fire({
            title: "Error al preparar datos",
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

// form-entrenamiento
document
  .getElementById("form-entrenamiento")
  .addEventListener("submit", function (event) {
    event.preventDefault();

    var formData = new FormData(this);

    fetch("/admin/entrenamiento", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          Swal.fire({
            title: "Entrenamiento exitoso",
            text: "El modelo se ha entrenado correctamente.",
            icon: "success",
            confirmButtonText: "OK",
          });
        } else {
          Swal.fire({
            title: "Error al entrenar modelo",
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
