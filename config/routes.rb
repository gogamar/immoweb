Rails.application.routes.draw do
  localized do
    resources :towns
    resources :listings
    get 'static/about_us', to: 'static#about_us', as: :about_us
    get 'static/terms'
    get 'static/contact', to: 'static#contact_us', as: :contact_us
    get 'static/all_listings', to: 'static#all_listings', as: :all_listings
    devise_for :users
    root to: "static#home"
  end
  get '/ca', to: redirect('/'), as: :redirect_default_locale
  get '*path' => 'application#redirect_to_homepage'
end
