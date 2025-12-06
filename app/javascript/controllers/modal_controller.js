import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    // close on click outside of modal
    this.dialogTarget.addEventListener('click', (event) => {
      if (event.target === this.dialogTarget) {
        this.close(event)
      }
    })
  }

  open(event) {
    event.preventDefault()
    this.dialogTarget.showModal()
  }

  close(event) {
    event.preventDefault()
    this.dialogTarget.close()
  }
}