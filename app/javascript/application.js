// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// fixme: remove add_jquery.js, and components/init_slick.js, components/init_magnificPopUp.js - not necessary because in importmap these packages are already pinned

// import "./add_jquery";
// import { initSlick } from "./components/init_slick";
// import { initMagnificPopUp } from "./components/init_magnificPopUp";

// document.addEventListener("turbo:load", function () {
//   initSlick();
//   initMagnificPopUp();
// });
