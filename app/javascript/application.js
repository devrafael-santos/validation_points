import "@hotwired/turbo-rails"
import "controllers"

const applyTheme = () => {
  if (localStorage.theme === "dark" || (!("theme" in localStorage) && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
    document.documentElement.classList.add("dark")
  } else {
    document.documentElement.classList.remove("dark")
  }
}

applyTheme()
document.addEventListener("turbo:load", applyTheme)
