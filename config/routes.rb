require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root "tasks#index"

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

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

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
