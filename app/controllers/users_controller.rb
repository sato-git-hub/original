class UsersController < ApplicationController
 
  def show
    @user = User.find(params[:id])
  end

  def portfolio
    @user = User.find(params[:user_id])
    @creator_setting = @user.creator_setting
  end

  def received_request
    @user = User.find(params[:user_id])
    @received_requests = @user.received_requests.publish.active
  end

  def sent_request
    @user = User.find(params[:user_id])
    @sent_requests = @user.requests.publish.active
  end

  def remember_me
    true
  end
end
