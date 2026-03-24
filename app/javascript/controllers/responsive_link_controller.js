import { Controller } from "@hotwired/stimulus"

export default class extends Controller {  
  click(event) {
    if (window.innerWidth < 650) {
      console.log(window.innerWidth)
      this.element.removeAttribute("data-turbo-frame")
    }
  }
}