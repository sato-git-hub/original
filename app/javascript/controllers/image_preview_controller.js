import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "title"]
  static values = {
    width: { type: String, default: "150px" }, 
    height: { type: String, default: "auto" },
    fit: { type: String, default: "cover" },
    position: { type: String, default: "center" }
  }

  preview(event) {
//存在する？
    if (this.previewAreaTarget){
      const area = this.previewAreaTarget.innerHTML
    }
    const files = event.target.files

    if(!files) return;
      if (this.hasTitleTarget) {
        this.titleTarget.classList.remove("hidden")
      }
      this.previewTarget.classList.remove("hidden")
      this.previewTarget.innerHTML = ""
    Array.from(files).forEach(file=>{
    if (!file.type.startsWith("image/")) return;

    const imageUrl = URL.createObjectURL(file);
    const img = document.createElement("img")
    img.src = imageUrl
    img.style.width = this.widthValue;
    img.style.height = this.heightValue;
    img.style.objectFit = this.fitValue;
    img.style.objectPosition = this.positionValue;
    img.classList.add("rounded");
    img.onload = () => {
      URL.revokeObjectURL(imageUrl); 
    };
  this.previewTarget.appendChild(img)
    })
}
}
