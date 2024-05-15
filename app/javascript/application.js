// Import third-party libraries
import "@hotwired/turbo-rails";

// Import modules managed by Importmap
import "add_jquery";
import "controllers";
import { initSlick } from "init_slick";
import { initMagnificPopUp } from "init_magnific_popup";

document.addEventListener("turbo:load", function () {
  initSlick();
  initMagnificPopUp();
});

// To add custom files to the importmap, pin them in importmap.rb and import them here.
