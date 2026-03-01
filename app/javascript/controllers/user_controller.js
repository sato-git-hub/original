import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]
  border(event) {

    this.linkTargets.forEach(link => {
      link.classList.remove("active")
      //link.classList.add("")
    });
    event.currentTarget.classList.add("active")
    //event.currentTarget.classList.remove("user-content-menu")
  }
}