class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only:[:new, :create]
  before_action :set_user, only:[:show, :edit, :update, :destroy]
  before_action :redirect_if_authenticated, only:[:new, :create]
  before_action :authorize_user!, only:[:edit, :update, :destroy]
  def index
  end
  
  def show
    
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to requests_path
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.delete
  end

private

  def authorize_user!
    @user = User.find(params[:id])
    #一致してたらこの関数を抜ける
    return if current_user.id == @user.id
    #一致しない場合 
    redirect_to user_path(current_user)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :password, :password_confirmation, :twitter, :pixiv, :instagram, :comment)
  end
end