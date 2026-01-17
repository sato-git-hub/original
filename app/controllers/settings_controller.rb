class SettingsController < ApplicationController
  def edit
    @user = current_user
    @portfolio = @user.portfolio
  end

  def update
    @user = current_user
    @portfolio = @user.portfolio
    if @portfolio.nil?
      redirect_to new_user_portfolio_path(@user), 
      alert: "ポートフォリオを作成しないと設定できません"
    end
    if @portfolio.update(setting_params)
      redirect_to @user
    else
        render :edit, status: :unprocessable_entity
    end
  end

  private
  def setting_params
    params.require(:portfolio).permit(:published)
  end
end
