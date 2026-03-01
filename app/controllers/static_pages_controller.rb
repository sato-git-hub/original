class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:after_registration_confirmation]
  def after_registration_confirmation
    @email = session[:registered_email] 
  end

end
