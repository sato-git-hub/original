class CreatorSettings::PublishesController < ApplicationController

  before_action :ensure_creator_setting!, only: [ :update ]

  def update
    creator_setting = current_user.creator_setting
    if creator_setting.update(publish_params)
      redirect_to current_user, notice: "更新に成功しました"
    else
        render :edit, alert: "更新できませんでした", status: :unprocessable_entity
    end
  end

  private

  # 「ポートフォリオの存在を確認する」
  def ensure_creator_setting!
    redirect_to new_user_creator_setting_path(current_user), alert: "ポートフォリオを作成しないと設定できません" unless current_user.creator_setting
  end

  def publish_params
    params.require(:creator_setting).permit(:published)
  end
end


