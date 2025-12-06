import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.close()
    }, 4000)
  }

  close() {
    this.element.classList.add("transition-all", "ease-in-out", "duration-500", "opacity-0", "translate-x-full")

    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}