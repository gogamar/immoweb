# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# pin "bootstrap", to: "bootstrap.min.js", preload: true
# pin "@popperjs/core", to: "popper.js", preload: true
# pin "bootstrap-bundle", to: "bootstrap.bundle.min.js", preload: true
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
pin "flatpickr", to: "flatpickr.js", preload: true
pin "jarallax", to: "jarallax.js", preload: true
pin "leaflet", to: "leaflet.js", preload: true
pin "lightgallery", to: "lightgallery.js", preload: true
pin "nouislider", to: "nouislider.min.js", preload: true
pin "prismjs", to: "prismjs.js", preload: true
pin "rellax", to: "rellax.js", preload: true
pin "smooth-scroll", to: "smooth-scroll.polyfills.min.js", preload: true
# pin "tiny-slider", to: "tiny-slider.js", preload: true
pin "theme.min", to: "theme.min.js", preload: true
