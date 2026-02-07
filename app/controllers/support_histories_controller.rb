class SupportHistoriesController < ApplicationController
  rescue_from ArgumentError, with: :support_error

  def create
    request = Request.find(params[:request_id])
    reward = params[:reward_id]
    
    request.support!(user: current_user, amount: support_history_params[:amount].to_i, payjp_token: params["payjp-token"])
    redirect_to request, notice: "支援が完了しました"
    rescue => e
    redirect_to request, alert: e.message
  end

  private

  def support_error(error)
    #このinstance 変数を使って"requests/show"が描画される
    @request = Request.find(params[:request_id])
    @support_history = @request.support_histories.build(
    amount: params[:amount]
  )
    flash.now[:alert] = "最低金額以上で入力してください"
    render "requests/show"
  end

  def support_history_params
  params.require(:support_history).permit(:amount)
  end
end