import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = [ "burger", "menu" ]

  toggle() {
    this.menuTarget.classList.toggle("is-active")
    this.burgerTarget.classList.toggle("is-active")
  }
}
