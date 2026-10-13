import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["iconDark", "iconLight"]

  connect() {
    this.updateIcons()
  }

  toggle() {
    const isDark = document.documentElement.classList.toggle("dark")
    localStorage.setItem("theme", isDark ? "dark" : "light")
    this.updateIcons()
  }

  updateIcons() {
    const isDark = document.documentElement.classList.contains("dark")
    if (this.hasIconDarkTarget && this.hasIconLightTarget) {
      if (isDark) {
        this.iconDarkTarget.classList.remove("hidden")
        this.iconLightTarget.classList.add("hidden")
      } else {
        this.iconDarkTarget.classList.add("hidden")
        this.iconLightTarget.classList.remove("hidden")
      }
    }
  }
}

