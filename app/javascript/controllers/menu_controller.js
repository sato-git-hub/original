import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle() {

    this.panelTarget.classList.toggle("hidden")
    
    const notificationList = document.querySelector('.notification-list-panel')
    if (notificationList && notificationList.classList.contains('active')) {
      notificationList.classList.remove('active')
    }
  }
}