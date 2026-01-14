Rails.application.routes.draw do

resources :users do
  resource :portfolio, only: [:new, :create, :edit, :update, :show]
end
resource :request


get "login", to: "sessions#new"
post "login", to: "sessions#create"
delete "logout", to: "sessions#destroy"
end
