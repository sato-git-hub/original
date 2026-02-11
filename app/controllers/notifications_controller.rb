class NotificationsController < ApplicationController

  def show
    @notifications = Notification.where(receiver: current_user).order(created_at: :desc)
    if params[:target] == "supporter"
      @notifications = Notification.where(receiver: current_user, target: :supporter).order(created_at: :desc)
    elsif params[:target] == "creator"
      @notifications = Notification.where(receiver: current_user, target: :creator).order(created_at: :desc)
    end
  end
  def checked
    @notification = Notification.find(params[:notification_id])
    @notification.checked!
    
    respond_to do |format|
      #turbo_stream形式のレスポンスを受け取ったら自動で .turbo_stream.erb を実行
      #@notificationが渡される
      format.turbo_stream
    end
    
  rescue => e
    Rails.logger.debug "DEBUG: keyword=#{e.message}"
    redirect_to notification_checked_path, alert: "更新に失敗しました"
  end
end
