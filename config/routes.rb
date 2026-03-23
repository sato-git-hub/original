require "sidekiq/web"

Rails.application.routes.draw do

  get "static_pages/after_registration_confirmation"

  devise_for :users, controllers: {
  registrations: 'users/registrations',
  confirmations: 'users/confirmations',
  #passwords: 'users/passwords'
}
# 本番時はif Rails.env.development?
#    mount LetterOpenerWeb::Engine, at: "/letter_opener"
# end　を消す


resources :received_requests, only: [:index, :show]
resources :sent_requests, only: [:index, :show]
resources :supported_requests, only: [:index, :show]
resources :drafts, only: [:index, :show]
resources :contacts, only: [:new, :create]

get 'user_menu', to: 'users#menu', as: :user_menu

root "requests#index"

resources :requests, only: [] do
  resource :deliverable, only: [:update]
end

resources :deliverables, only: [] do
  member do
    get :download
  end
end

resources :deliverables, only: [:index]

# 確認メール送信後
get 'after_registration_confirmation', to: 'static_pages#after_registration_confirmation'

# ログインしているとき
authenticated :user do
  # ログインしている時だけ、ここが「本当のトップ」になる
  root 'dashboard#show', as: :signed_in_root
end

# mount Sidekiq::Web => "/sidekiq"

resource :deposit, only: [:new, :create, :edit, :update, :show]

resource :notification, only: [ :show ]

resources :notifications, only: [] do
  patch :checked
end

resource :creator_setting do
  member do
    delete :remove_image
    post :add_image
  end
end

namespace :creator_settings, only: [] do
    resource :publish, only: [ :update ]
end

resource :creator_setting, only: [ :new, :create, :edit, :update]

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

resources :portfolios, only: [ :index ]

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

resources :requests do
  member do
    get :preview
    get :detail
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