class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時に name カラムを許容する場合
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name,
      :twitter,
      :instagram,
      :pixiv,
      :avatar
    ])
    # アカウント編集時に name カラムを許容する場合
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :name,
      :twitter,
      :instagram,
      :pixiv,
      :avatar,
      :remove_avatar,
      :sign_in, keys: [:remember_me]
    ])
  end

  private

  def render_404
    render file: Rails.root.join("public/404.html"),
           status: :not_found,
           layout: false
  end
end
