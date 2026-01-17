Rails.application.routes.draw do

#new_user_setting GET    /users/:user_id/setting/new settings#new
#user_setting POST   /users/:user_id/setting settings#create


resource :setting, only: [:edit, :update]  


resources :users do
  resource :portfolio, only: [:new, :create, :edit, :update, :show]
end

#リクエストを送るボタンを押しときのURL
# users/user_id/request/new new_user_request_path => requests#new
resources :users, only: [] do
  resources :requests, only: [:new, :create]  #送信　users/user_id/request　user_request_path => requests#create
end
resources :requests, only: [:index, :show]

get "login", to: "sessions#new"
post "login", to: "sessions#create"
delete "logout", to: "sessions#destroy"
end
