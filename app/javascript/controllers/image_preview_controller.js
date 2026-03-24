import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static targets = ["preview"]
  static values = {
    width: { type: String, default: "150px" }, 
    height: { type: String, default: "auto" },
    fit: { type: String, default: "cover" },
    position: { type: String, default: "center" }
  }

  add(event) {
//存在する？
    const input = event.currentTarget
    const form = input.form 
    if (form) {
      form.requestSubmit()
    } 
  }
}
