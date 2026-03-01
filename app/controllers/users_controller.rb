class UsersController < ApplicationController
 
  def menu

    @user = User.includes(:deposit, :creator_setting).find(current_user.id)
    # レイアウト（ヘッダーやフッター）を除いた、中身だけを返す
    render partial: 'shared/user_menu', locals: { user: @user }, layout: false
  end

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
    @sent_requests = @user.requests
    .with_attached_request_images
    .publish
    .active
  end


  def remember_me
    true
  end
end
