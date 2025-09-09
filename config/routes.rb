Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  resources :categories, only: [:show]
  resources :products, only: [:index, :show]
  
  resource :cart, only: [:show] do
    post :add_item
    patch :update_item
    delete :remove_item
    delete :empty
  end
  
  resource :profile, only: [:show, :edit, :update] do
    member do
      delete :destroy_account
    end
  end

  resources :checkouts, only: [:create]
  
  resources :orders, only: [:index, :show] do
    member do
      patch :cancel
    end
  end

  get "/about" => "static_pages#about", as: :about
  get "/contact" => "static_pages#contact", as: :contact
  get 'checkouts', to: 'checkouts#show'
  get 'checkouts/success', to: 'checkouts#success', as: 'checkouts_success'

  # Stripe webhooks
  mount StripeEvent::Engine, at: "/stripe/webhooks", to: "stripe_webhooks#create"

  namespace :admin do
    resources :users
    resources :products
    resources :categories
    
    # Admin order management
    resources :orders, only: [:index, :show] do
      member do
        patch :mark_as_paid
        patch :mark_as_shipped
        patch :cancel
      end
    end
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end