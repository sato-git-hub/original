class PaymentsController < ApplicationController

  def create
    current_user.register_card(params["payjp-token"])
      redirect_to setting_path, notice: "決済情報の登録が完了しました"
    rescue => e
      redirect_to setting_path, alert: e.message
  end

  def edit 

  end
end