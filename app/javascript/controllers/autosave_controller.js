import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="autosave"
export default class extends Controller {
  //autosaveコントローラーのsaveアクション
  save() {
    // 紐付いている要素を送信する
    this.element.requestSubmit();
  }
}
