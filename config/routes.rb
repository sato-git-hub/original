require "sidekiq/web"

Rails.application.routes.draw do
  get "static_pages/after_registration_confirmation"
  devise_for :users, controllers: {
  registrations: 'users/registrations',
  confirmations: 'users/confirmations'
}

if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
end

root "requests#index"

# 確認メール送信後
get 'after_registration_confirmation', to: 'static_pages#after_registration_confirmation'

# mount Sidekiq::Web => "/sidekiq"

resource :deposit, only: [:new, :create, :edit, :update, :show]

resource :notification, only: [ :show ]

resources :notifications, only: [] do
  patch :checked
end

namespace :creator_settings, only: [] do
    resource :publish, only: [ :update ]
end

resources :creator_settings, only: [ :index, :new, :create, :edit, :update]

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

resources :requests, only: [] do # /requests/:id/
  get :delivery_list, to: "support_histories#delivery_list"
end

resources :support_histories, only: [ :index ]

resources :requests, only: [] do # /requests/
  collection do
    get :dashboard
    get :incoming
  end
end

resources :requests
resources :users, only: [] do
  get :portfolio
  get :received_request
  get :sent_request
  get :supported_request
end
resources :users, only: [ :show ]

end

# docker compose exec web bundle exec rails routes