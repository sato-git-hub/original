require "sidekiq/web"

Rails.application.routes.draw do
  # 本番環境では devise 等で認証をかけないと誰でも見れてしまうので注意！
  mount Sidekiq::Web => "/sidekiq"

resources :requests, only: [] do
  scope module: :requests do
    resource :reward, only: [ :new, :create ]
  end
end

resources :users
resource :payment, only: [ :create, :update ]

resource :notification, only: [ :show ]

resources :notifications, only: [] do
  patch :checked
end

resource :setting, only: [ :show ]


namespace :portfolios, only: [] do
    resource :publish, only: [ :update ]
end

resources :portfolios

resources :requests, only: [] do
  scope module: :requests do
    resource :status, only: [] do
      # draft → waiting_for_approval
      patch :submit
      # waiting_for_approval → approved
      patch :approve
      # → creator_declined
      patch :decline
    end
  end
end

resources :requests, only: [] do # /requests/:id/
  resources :support_histories, only: [ :new, :create ]
end

resources :requests, only: [] do # /requests/
  collection do
    get :dashboard
    get :incoming
  end
end

resources :requests

get "login", to: "sessions#new"
post "login", to: "sessions#create"
delete "logout", to: "sessions#destroy"
end

# docker compose exec web bundle exec rails routes