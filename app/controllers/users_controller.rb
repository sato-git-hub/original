class UsersController < ApplicationController
 
  def menu

    @user = User.includes(:deposit, :creator_setting).find(current_user.id)
    # レイアウト（ヘッダーやフッター）を除いた、中身だけを返す
    render partial: 'shared/user_menu', locals: { user: @user }, layout: false
  end

  def show
    @user = User.find(params[:id])
    @request = @user.received_requests.completed
    @deliverables = @request.deliverable
    # 期限が過ぎた
    @creator_setting = @user.creator_setting
  end

  def portfolio
    @user = User.find(params[:user_id])
    @creator_setting = @user.creator_setting
  end

  def received_request
    @user = User.find(params[:user_id])
    @requests = @user.received_requests.publish
    .with_attached_request_images
  end

  def sent_request
    @user = User.find(params[:user_id])
    @requests = @user.requests.publish
    .with_attached_request_images
  end

  def supported_request
    @user = User.find(params[:user_id])
    @requests = @user.supported_requests.distinct
  end

  def remember_me
    true
  end
end
