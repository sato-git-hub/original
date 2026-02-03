document.addEventListener("turbo:load", () => {
  const swiperEl = document.querySelector(".swiper");
  if (!swiperEl) return;
  const swiper = new Swiper('.swiper', {
  direction: 'horizontal',
  allowTouchMove: false,
});

let startX = 0;
let startTranslateX = 0;
let bool = false;
const wrapper = document.querySelector(".swiper-wrapper")

document.addEventListener("pointerdown", (e) => {
// マウス、トランスパッドのクリックで操作する場合
  //if (e.pointerType === "mouse"){
  //  if (e.target.closest(".swiper-button-prev")){
  //    swiper.slidePrev();
  //  }else if (e.target.closest(".swiper-button-next")){
  //      swiper.slideNext();
  //  }
// 画面をタッチして、またはタッチペンで操作する場合
  if (e.pointerType === "mouse"){
    if (!e.target.closest(".swiper"))return;
    startX = e.clientX;
    console.log(startX)
    bool = true;
    startTranslateX = swiper.getTranslate()
  }
});

document.addEventListener("pointermove", (e) => {
  if (e.pointerType === "mouse"){
  if (!bool) return;
  const diff = e.clientX - startX;
  const newX = startTranslateX + diff;
  swiper.setTransition(0);
  swiper.setTranslate(newX)
  }
});

document.addEventListener("pointerup", (e) => {
  if (e.pointerType === "mouse"){
  if (!bool) return;
  bool = false;
  const diff = e.clientX - startX;
   if (diff > 300) {
    swiper.slidePrev();
  } else if (diff < -300) {
    swiper.slideNext();
  }else {
    swiper.setTransition(300);
    swiper.setTranslate(startTranslateX);
  }
}
});
});

