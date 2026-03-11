import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["newForm"]
  
  toggle(event) {

//e.target.checked: クリックされたら必ずtrue 何回押してもtrue
    if (event.target.value === "registered"){
      this.newFormTarget.classList.add("hidden")
    }else{
      this.newFormTarget.classList.remove("hidden")
    }
  }
}
