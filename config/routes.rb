Rails.application.routes.draw do
  root "bikes#index"

  resources :bikes do
    resources :bike_components, only: %i[new create destroy]
    resources :maintenance_logs, only: %i[index new create show edit update destroy]
  end

  resources :components

  get "signup", to: "users#new", as: :signup
  post "signup", to: "users#create"

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout
end
