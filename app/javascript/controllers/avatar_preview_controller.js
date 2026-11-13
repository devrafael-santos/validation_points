import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["output", "placeholder"];

  preview(event) {
    const file = event.target.files[0];
    const allowedTypes = ["image/png", "image/jpeg", "image/jpg"];

    if (file && allowedTypes.includes(file.type)) {
      this.outputTarget.src = URL.createObjectURL(file);
      this.outputTarget.classList.remove("hidden");
      this.placeholderTarget.classList.add("hidden");
    } else if (file) {
      alert("Por favor, selecione uma imagem no formato PNG ou JPG.");
      event.target.value = "";
    }
  }
}
