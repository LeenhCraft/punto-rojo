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
          alert(data.message);
        } else {
          alert("Error al importar datos.");
        }
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  });
