import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["previewArea"]

  check(e) {
    const input = e.target
    if (input.files && input.files[0]) {
      const container = input.closest(".deliverable-input-area")
      const fileName = input.files[0].name
      container.querySelector(".file-input").innerHTML=fileName
    }
    
  }
}