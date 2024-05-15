// Import third-party libraries
import "@hotwired/turbo-rails";

// Import modules managed by Importmap
import "./add_jquery";
import { initSlick } from "./components/init_slick";
import { initMagnificPopUp } from "./components/init_magnificPopUp";

document.addEventListener("turbo:load", function () {
  initSlick();
  initMagnificPopUp();
});
