class RequestsController < ApplicationController
  before_action :set_request, only: [ :edit, :show, :update ]
  before_action :authorize_user!, only: [ :update ]
  before_action :authorize_approved_or_succeeded!, only: [ :show ]

  before_action :ensure_draft!, only: [ :edit, :update ]
  # 受け取ったリクエスト一覧
  def incoming
    @q = Request.ransack(params[:q])
    @requests = @q.result.where(creator: current_user).where.not(status: [ :draft, :creator_declined ]).order(updated_at: :desc)
  end

  def dashboard
    @q = Request.ransack(params[:q])
    # Request.where(status: 1)
    @requests = @q.result.where(user: current_user).order(updated_at: :desc)
  end

  def index

    base_query = Request.where(status: [:approved, :succeeded]).active
    # 全てのリクエストを一覧
    # とどいたparams
    search_params = params[:q] || {}
    if search_params[:title_or_search_conf_cont].present?

      words = search_params[:title_or_search_conf_cont].split(/[[:space:]]+/)
      # titleまたはsearch_conf に渡した すべての words を含んでいるレコード

      # formから受け取ったparamsを加工せず、そのまま絞る時は@q = Request.ransack(params[:q])
      # 空白で分割して絞り込み検索
      @q = base_query.ransack(title_or_search_conf_cont: words)
    else
      # 空で渡す
      @q = base_query.ransack(search_params)
      # .active.where("deadline_at >= ?", Time.current)
    end

    @requests = @q.result(distinct: true)
                .with_attached_request_images
                .preload(:support_histories, user: { avatar_attachment: :blob }) # ← SELECT * FROM users WHERE id IN (1, 2, 3...)
                .order(updated_at: :desc)
  end

  def new
    @request = Request.new
    @creator_setting = CreatorSetting.find(params[:creator_setting_id])
  end

  def create
    @request = current_user.requests.build(request_params)
    @creator_setting = CreatorSetting.find(params[:creator_setting_id])
    @creator = @creator_setting.user
    @request.creator = @creator
    if @request.save
        @request.submit! if params[:commit] == "send"
        redirect_to current_user,notice: "処理に成功しました"
    else
      flash.now[:alert] = "処理に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show

    @request = Request.preload(
      :request_images_attachments,
      creator: [
        :avatar_attachment, # 作成者のアバター
        { creator_setting: :images_attachments }
      ]
    ).find(params[:id])
    
    @support_history = @request.support_histories.build
    @supporters_count = @request.support_histories.distinct.count(:user_id)
  end

  def edit
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
    # リクエストを取得
    @request = Request.find(params[:id])
    @request.destroy
  end

private

  def set_request
    @request = Request.find(params[:id])
  end

  # approvedとsucceeded以外のリクエストは入金ページを表示できない # approvedであるか
  def authorize_approved_or_succeeded!
    unless @request.approved? || @request.succeeded?
      redirect_to current_user, alert: "このリクエストは非公開です"
    end
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
  end
end
