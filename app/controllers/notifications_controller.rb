class NotificationsController < ApplicationController

  def show
    @notifications = Notification.where(receiver: current_user).order(updated_at: :desc)
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
