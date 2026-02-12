class SupportHistoriesController < ApplicationController
  before_action :authorize_request_publish!, only: [:new, :create]
  def new 
    @reward = Reward.find(params[:reward_id])
    @support_history = SupportHistory.new
  end

  def create
    #新規を選んだ場合、

    reward = Reward.find(params[:reward_id])
    # has_many :support_histories, dependent: :destroy
    support_history = @request.support_histories.build(support_history_params)
    support_history.reward = reward
    support_history.user = current_user
    support_history.amount = reward.amount
    support_history.save!
    @request.support!(user: current_user, reward_id: params[:reward_id], payjp_token: params["payjp-token"])

    redirect_to @request, notice: "支援が完了しました"
    rescue => e
    redirect_to @request, alert: e.message
  end

  private

  def support_history_params
  params.require(:support_history).permit(:shipping_postal_code, :shipping_prefecture, :shipping_city, :shipping_address_line1, :shipping_address_line2, :shipping_phone_number)
  end

  def authorize_request_publish!
    @request = Request.find(params[:request_id])
    redirect_to current_user, alert: "公開期間が終了したリクエストです" unless @request.published?
  end

end