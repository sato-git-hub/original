class SupportHistoriesController < ApplicationController
  before_action :authorize_request_publish!, only: [ :new, :create ]
  def new

    @support_history = SupportHistory.new
  end

  def create
    
    support_history = @request.support_histories.build
    support_history.user = current_user
    support_history.save!(support_history_params)
    Rails.logger.debug "DEBUG: keyword=#{support_history.inspect}========================="
    @request.support!(user: current_user, amount: support_history_params[:amount], payjp_token: params["payjp-token"])

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

  def index
    @q = current_user.support_histories
              .ransack(params[:q])
    @support_histories = @q.result
  end

  private

  def support_history_params
    params.require(:support_history).permit(:amount)
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
