import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]
  toggle(event) {
    if (!this.listTarget.classList.contains("active")) {
    this.listTarget.classList.add("active")
    } else {
      event.preventDefault() 
      this.listTarget.classList.remove("active")
    }
    const menuList = document.querySelector(".user-menu")
    if (menuList && !menuList.classList.contains("hidden")) {
      menuList.classList.add('hidden')
    }
  }
}