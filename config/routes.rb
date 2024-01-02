Rails.application.routes.draw do
  resources :towns
  resources :listings
  get 'static/about_us'
  get 'static/terms'
  get 'static/contact'
  devise_for :users
  root to: "static#home"
end
