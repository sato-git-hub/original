import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["registeredForm", "newForm"]
  toggle(event) {

//e.target.checked: クリックされたら必ずtrue 何回押してもtrue
    if (event.target.value === "registered"){
      this.registeredFormTarget.classList.remove("hidden")
      this.newFormTarget.classList.add("hidden")
    }else{
      this.newFormTarget.classList.remove("hidden")
      this.registeredFormTarget.classList.add("hidden")
    }
  }
}
