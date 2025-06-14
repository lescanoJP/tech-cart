require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products
  resources :carts, only: [:create, :index] do
    collection do
      put :add_item
      delete ':product_id', to: 'carts#destroy'
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
