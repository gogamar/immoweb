# Pin npm packages by running ./bin/importmap


pin "application"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@3.1.2/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/process-production.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "simplebar", to: "simplebar.min.js", preload: true
pin "@lottiefiles/lottie-player", to: "@lottiefiles--lottie-player.js" # @2.0.4
pin "cleave.js" # @1.6.0
pin "filepond" # @4.31.1
pin "filepond-plugin-file-validate-size" # @2.2.8
pin "filepond-plugin-file-validate-type" # @1.2.9
pin "filepond-plugin-image-crop" # @2.0.6
pin "filepond-plugin-image-preview" # @4.6.12
pin "filepond-plugin-image-resize" # @2.0.10
pin "filepond-plugin-image-transform" # @3.8.7
# pin "jarallax", to: "jarallax.min.js"
pin "leaflet", to: "leaflet.js"
pin "lightgallery", to: "lightgallery.min.js"
pin "lightgallery-plugin-fullscreen", to: "lg-fullscreen.min.js"
pin "lightgallery-plugin-zoom", to: "lg-zoom.min.js"
pin "lightgallery-plugin-thumbnail", to: "lg-thumbnail.min.js"
pin "flatpickr", to: "flatpickr.js"
pin "prismjs", to: "prismjs.js"
pin "rellax", to: "rellax.js"
pin "smooth-scroll", to: "smooth-scroll.polyfills.min.js"
pin "theme", to: "theme.min.js"
