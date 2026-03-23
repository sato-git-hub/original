class UsersController < ApplicationController
 
  def menu

    @user = User.includes(:deposit, :creator_setting).find(current_user.id)
    # レイアウト（ヘッダーやフッター）を除いた、中身だけを返す
    render partial: 'shared/user_menu', locals: { user: @user }, layout: false
  end

  def show
    @user = User.find(params[:id])
    # statusが完了になっている受け取ったリクエスト
    @requests = @user.received_requests.completed.with_attached_deliverable
    base = @user.received_requests
    @ont = (base.on_time.count.zero?)? 0 : (base.on_time.count.to_f / (base.off_time.count + base.on_time.count)*100).round
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
    # request_idの重複を除去
    @requests = @user.supported_requests.distinct
  end

  def remember_me
    true
  end
end
