// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// Import third-party libraries
import "@hotwired/turbo-rails";
// import "jquery";
// import "slick-carousel";
// import "magnific-popup";
import "mapbox-gl";

// Import controllers (assuming they are Stimulus controllers)
import "controllers";

import "./add_jquery";
import { initSlick } from "./components/init_slick";
import { initMagnificPopUp } from "./components/init_magnificPopUp";

document.addEventListener("turbo:load", function () {
  initSlick();
  initMagnificPopUp();
});
