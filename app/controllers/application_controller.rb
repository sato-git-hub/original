class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  #rescue_from ActiveRecord::RecordNotFound, with: :render_404
  helper_method :current_user #ビューで使えるようになる
  private

  def render_404
    render file: Rails.root.join("public/404.html"),
           status: :not_found,
           layout: false
  end

  def current_user
    #sessionが空でなければ　すでに新規登録またはログインしている
    if session[:user_id]
    #空だったときだけsurrent_uerにUser情報を入れる 
    current_user||=User.find(session[:user_id])
    end
  end

  def authenticate_user!
    redirect_to login_path unless current_user
  end

  def redirect_if_authenticated
    redirect_to user_path(current_user) if current_user
  end  
end
