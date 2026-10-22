import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["output", "placeholder"];

  preview(event) {
    const file = event.target.files[0];

    if (file) {
      this.outputTarget.src = URL.createObjectURL(file);
      this.outputTarget.classList.remove("hidden");
      this.placeholderTarget.classList.add("hidden");
    }
  }
}
