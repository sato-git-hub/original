import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "container"]
  add(event) {
    event.preventDefault()
    //コピーしたもののNEW_RECORD部分を現在時刻に
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    //
    this.containerTarget.insertAdjacentHTML('beforeend', content)
  }
}
