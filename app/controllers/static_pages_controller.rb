class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:after_registration_confirmation]
  before_action :redirect_if_signed_in, only: [:after_registration_confirmation]
  def after_registration_confirmation
    @email = session[:registered_email] 
  end

  private
  def redirect_if_signed_in
    redirect_to root_path if user_signed_in?
  end
end
