Rails.application.routes.draw do

  localized do
    # Sidekiq Web UI, only for admins.
    require "sidekiq/web"
    require 'sidekiq/cron/web'
    authenticate :user, ->(user) { user.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
    resources :features
    resources :image_urls
    resources :towns
    resources :listings
    resources :services
    resources :contents
    resources :contacts
    resources :offices

    get 'static/about_us', to: 'static#about_us', as: :about_us
    get 'static/success', to: 'static#success', as: :success
    get 'static/terms'
    get 'static/contact', to: 'static#contact_us', as: :contact_us
    get 'static/sale_listings', to: 'static#sale_listings', as: :sale_listings
    get 'static/rental_listings', to: 'static#rental_listings', as: :rental_listings
    get 'get_operations_and_listing_types', to: 'static#get_operations_and_listing_types', as: :get_operations_and_listing_types
    get 'contact_submit', to: 'contacts#submit'

    devise_for :users
    root to: "static#home"
  end
  get '/ca', to: redirect('/'), as: :redirect_default_locale
  get '*path' => 'application#redirect_to_homepage'
end
