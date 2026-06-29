Rails.application.routes.draw do
  devise_for :users
  
  get "up" => "rails/health#show", as: :rails_health_check

  root "movies#index"
  resources :movies, only: [:index, :show]
  resources :seat_locks, only: [:create, :destroy]
  resources :bookings, only: [:index, :show, :create]
  resources :shows, only: [:index, :show, :create, :update, :destroy]
  namespace :admin do
    resources :movies, only: [:index, :create, :show, :destroy]
  end
  resources :theaters do
    resources :screens, only: [:create, :show, :destroy]
  end
  resources :seat_locks, only: [:destroy] do
    collection do
      post :create_multiple
    end
  end
end
