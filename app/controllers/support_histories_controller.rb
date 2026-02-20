class SupportHistoriesController < ApplicationController
  before_action :authorize_request_publish!, only: [ :new, :create ]
  def new
    @reward = Reward.find(params[:reward_id])
    @support_history = SupportHistory.new
  end

  def create
    # 新規を選んだ場合、
    reward = Reward.find(params[:reward_id])
    
    support_history = @request.support_histories.build(support_history_params) if reward.has_shipping?
    support_history = @request.support_histories.build unless reward.has_shipping?
    support_history.reward = reward
    support_history.user = current_user
    support_history.amount = reward.amount
    support_history.save!
    @request.support!(user: current_user, reward_id: params[:reward_id], payjp_token: params["payjp-token"])

    redirect_to @request, notice: "支援が完了しました"
    rescue => e
      redirect_to @request, alert: e.message
  end

  def delivery_list
    @request = Request.find(params[:request_id])
    Rails.logger.debug "DEBUG: keyword=#{@request.support_histories}========================="
    @support_histories = @request.support_histories
    Rails.logger.debug "DEBUG: keyword=#{@support_histories}================================="
  end

  private

  def support_history_params
  params.require(:support_history).permit(:user_name, :shipping_postal_code, :shipping_prefecture, :shipping_city, :shipping_address_line1, :shipping_address_line2, :shipping_phone_number)
  end

  def authorize_request_publish!
    @request = Request.find(params[:request_id])
    redirect_to current_user, alert: "公開期間が終了したリクエストです" unless @request.approved? || @request.succeeded?
  end

  def authenticate_creator!
    @request = Request.find(params[:request_id])
    redirect_to current_user, alert: "不正なアクセスです" unless @request.creator == current_user
  end
end
