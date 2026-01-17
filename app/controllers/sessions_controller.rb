class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only:[:new, :create]
  before_action :redirect_if_authenticated, only:[:new, :create]
  def new
  end

  def create
    @user =  User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to requests_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
