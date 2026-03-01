class CreatorSettingsController < ApplicationController

  #before_action :creator_setting_set!, only: [ :show ]
  before_action :redirect_if_deposit_exists, only: [ :new, :create, :edit, :update ]
  before_action :redirect_if_creator_setting_exists, only: [ :new, :create ]
  before_action :redirect_unless_creator_setting_exists, only: [ :edit ]

  def new
    @creator_setting = CreatorSetting.new
  end

  def create
    @creator_setting = current_user.build_creator_setting(creator_setting_params)
    if @creator_setting.save
      redirect_to current_user, notice: "処理に成功しました"
    else
      flash.now[:alert] = "処理に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @creator_setting = current_user.creator_setting
  end

  def update
    ActiveRecord::Base.transaction do

      @creator_setting = current_user.creator_setting
      if params[:remove_image_ids].present?
        attachments = @creator_setting.images.where(id: params[:remove_image_ids])
        if @creator_setting.images.attachments.count - attachments.count <= 0
          raise StandardError, "画像は少なくとも1枚必要です"
        end
        attachments.each(&:purge)
      end

      @creator_setting.update!(creator_setting_params.except(:images))

      if creator_setting_params[:images].present?
          @creator_setting.images.attach(creator_setting_params[:images]) 
      end

    end

    redirect_to @creator_setting, notice: "ポートフォリオを更新しました"

  rescue => e
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  private

  def redirect_if_deposit_exists
    # 存在しなければ 銀行口座登録
    redirect_to new_deposit_path unless current_user.deposit
  end


  def redirect_if_creator_setting_exists
    redirect_to edit_creator_setting_path, alert: "ポートフォリオはすでに作成されています" if current_user.creator_setting
  end

  def redirect_unless_creator_setting_exists
    redirect_to new_creator_setting_path, alert: "ポートフォリオを作成してください" unless current_user.creator_setting
  end

  def creator_setting_params
    params.require(:creator_setting).permit(:body, :published, :minimum_supporters, :minimum_amount, images: [])
  end
end
