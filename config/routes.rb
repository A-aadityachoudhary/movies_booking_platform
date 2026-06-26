Rails.application.routes.draw do
  devise_for :users
  
  get "up" => "rails/health#show", as: :rails_health_check

  
  resources :movies, only: [:index, :show]
  resources :seat_locks, only: [:create, :destroy]
  resources :bookings, only: [:index, :show, :create]
  resources :shows, only: [:index, :create, :update, :destroy]
  namespace :admin do
    resources :movies, only: [:create, :show, :destroy]
  end
  resources :theaters do
    resources :screens, only: [:create, :show, :destroy]
  end
end
