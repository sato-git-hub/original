import Swiper from 'swiper';

document.addEventListener("turbo:load", () => {
  const swiperEl = document.querySelector(".swiper");
  if (!swiperEl) return;

  const swiper = new Swiper(swiperEl, {
    direction: "horizontal",
    allowTouchMove: false,
  });

  let startX = 0;
  let startTranslateX = 0;
  let isDragging = false;

  swiperEl.addEventListener("pointerdown", (e) => {
    if (e.pointerType === "mouse") {
      if (e.target.closest(".swiper-button-prev")) swiper.slidePrev();
      if (e.target.closest(".swiper-button-next")) swiper.slideNext();
      return;
    }

    startX = e.clientX;
    startTranslateX = swiper.translate;
    isDragging = true;
  });

  swiperEl.addEventListener("pointermove", (e) => {
    if (!isDragging) return;
    const diff = e.clientX - startX;
    swiper.setTransition(0);
    swiper.setTranslate(startTranslateX + diff);
  });

  swiperEl.addEventListener("pointerup", (e) => {
    if (!isDragging) return;
    isDragging = false;

    const diff = e.clientX - startX;
    if (diff > 300) swiper.slidePrev();
    else if (diff < -300) swiper.slideNext();
    else {
      swiper.setTransition(300);
      swiper.setTranslate(startTranslateX);
    }
  });
});
