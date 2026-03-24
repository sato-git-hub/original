class RequestsController < ApplicationController
  before_action :set_request, only: [ :edit, :show, :update, :destroy, :preview]
  before_action :authorize_user!, only: [ :update ]
  before_action :ensure_draft!, only: [ :edit, :update ]
  #before_action :ensure_editable_status, only: [ :destroy ]

  def index
    Rails.logger.debug "=============================================#{params[:q]}"
    base_query = Request.where(status: [:approved, :succeeded]).active
    # 全てのリクエストを一覧
    # とどいたparams
    search_params = params[:q] || {}
    if search_params[:title_or_search_conf_cont].present?

      words = search_params[:title_or_search_conf_cont].split(/[[:space:]]+/)
      # titleまたはsearch_conf に渡した すべての words を含んでいるレコード
      Rails.logger.debug "=============================================#{words}"
      # formから受け取ったparamsを加工せず、そのまま絞る時は@q = Request.ransack(params[:q])
      # 空白で分割して絞り込み検索
      keywords = words.reduce({}) do |hash, word|
        hash[word] = {title_or_search_conf_cont: word}
        hash
      end
      Rails.logger.debug "=============================================#{keywords}"
      @q = base_query.ransack({ combinator: 'and', groupings: keywords })

      Rails.logger.debug "=============================================#{@q}"
    else
      # 空で渡す
      @q = base_query.ransack(search_params)
      # .active.where("deadline_at >= ?", Time.current)
    end

    @requests = @q.result(distinct: true)
                .with_attached_request_images
                .preload(:support_histories, user: { avatar_attachment: :blob }) 
                .order(updated_at: :desc)
  end

  def new
    @request = Request.new
    @creator_setting = CreatorSetting.find(params[:creator_setting])
  end

  def create
    @request = current_user.requests.build(request_params)
    @creator_setting = CreatorSetting.find(params[:creator_setting_id])
    @creator = @creator_setting.user
    @request.creator = @creator
    if  @request.save
      @request.submit! if params[:commit] == "send"
      redirect_to current_user, notice: "処理に成功しました"
    else
      flash.now[:alert] = "処理に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @request = Request
      .with_attached_request_images
      .preload(
      creator: [
      :received_requests,
      { creator_setting: { images_attachments: :blob } },
      { avatar_attachment: :blob }
      ]
    ).find(params[:id])
  end

  def edit
    @creator_setting = CreatorSetting.find_by(user: @request.creator)
  end

  def update
    ActiveRecord::Base.transaction do

      if params[:remove_image_ids].present?
        attachments = @request.request_images.where(id: params[:remove_image_ids])
        if @request.request_images.attachments.size - attachments.size <= 0
          raise StandardError, "画像は少なくとも1枚必要です"
        end
        attachments.each(&:purge)
      end

      @request.update!(request_params.except(:request_images))

      if request_params[:request_images].present?
          @request.request_images.attach(request_params[:request_images]) 
      end
    end

    redirect_to current_user, notice: "更新しました"

  rescue => e
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @request.destroy
    flash[:notice] = "下書きを削除しました"
    respond_to do |format|
    format.turbo_stream {
      render turbo_stream: [
        turbo_stream.remove("request_#{@request.id}"),
        turbo_stream.remove("preview_request_#{@request.id}"),
        turbo_stream.update("flash", partial: "shared/flash_messages" )
      ]
    }
    format.html { redirect_to drafts_path, notice: "削除しました" }
    end
  end

private

  def set_request
    @request = Request.find(params[:id])
  end

  # 操作しているのが依頼者でない場合弾く
  def authorize_user!
    @user = @request.user
    raise ActiveRecord::RecordNotFound unless @user == current_user
  end

  # 操作しているのがクリエーターでない場合弾く
  def authorize_creator!
    @creator = @request.creator
    raise ActiveRecord::RecordNotFound unless @creator == current_user
  end

  # 送信済みのリクエストは編集できませんと表示させるため
  def ensure_draft!
    return if @request.draft?
    redirect_to request_path(@request),
    alert: "送信済みのリクエストは編集できません"
  end

  def request_params
    params.require(:request).permit(:title, :body, :target_amount, request_images: [])
    .tap do |whitelisted|
      whitelisted[:request_images] = whitelisted[:request_images].reject(&:blank?)
    end
  end

  def ensure_editable_status
    return if @request.draft?
    redirect_to request_path(@request),alert: "送信済みのリクエストは削除できません"
  end
end