import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "link"]
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
  show(e){
    this.linkTargets.forEach(link => {
      link.classList.remove("active")
    });
    e.currentTarget.classList.add("active")

  }
}