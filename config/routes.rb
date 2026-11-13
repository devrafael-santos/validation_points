Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root "tasks#index"

  resources :tasks do
    member do
      patch :toggle_reviewer
    end
  end

  resources :users, only: %i[ show ]

  namespace :admin do
    root to: "dashboard#index"
    resources :users, only: %i[ index update destroy ]
  end
end
