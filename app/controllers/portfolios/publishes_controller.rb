class Portfolios::PublishesController < ApplicationController
  before_action :ensure_portfolio!, only: [ :update ]

  def update
    portfolio = current_user.portfolio
    if portfolio.update(publish_params)
      redirect_to current_user, notice: "更新に成功しました"
    else
        render :edit, alert: "更新できませんでした", status: :unprocessable_entity
    end
  end

  private

  # 「ポートフォリオの存在を確認する」
  def ensure_portfolio!
    redirect_to new_user_portfolio_path(current_user), alert: "ポートフォリオを作成しないと設定できません" unless current_user.portfolio
  end

  def publish_params
    params.require(:portfolio).permit(:published)
  end
end
