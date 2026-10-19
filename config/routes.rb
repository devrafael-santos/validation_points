Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root "tasks#index"

  resources :tasks, only: %i[index show update] do
    member do
      patch :toggle_reviewer
    end
  end
end
