class RequestsController < ApplicationController
  before_action :set_request, only: [:edit, :show, :update]
  before_action :authorize_user!, only: [:update]
  before_action :authorize_approved_or_succeeded!, only: [:show]
  before_action :authorize_publish!, only: [:show]
  before_action :ensure_draft!, only: [:edit, :update]
  # 受け取ったリクエスト一覧
  def incoming
  # クリエーターとして関わるリクエスト #requestモデルにて received_requestsがrequestsテーブルのcreator_id == current_user.id
    @q = Request.ransack(params[:q])
    @requests = @q.result.where(creator: current_user).where.not(status: [:draft, :creator_declined, ]).order(updated_at: :desc)
  end

  def dashboard
      @q = Request.ransack(params[:q])
      # Request.where(status: 1)
      @requests = @q.result.where(user: current_user).order(updated_at: :desc)
  end

  def index
    #全てのリクエストを一覧
    if params[:q].present? && params[:q][:title_or_search_conf_cont].present?
      words = params[:q][:title_or_search_conf_cont].split(/[[:space:]]+/)
      #titleまたはsearch_conf に渡した すべての words を含んでいるレコード
      @q = Request.ransack(
      #formから受け取ったparamsを加工せず、そのまま絞る時は@q = Request.ransack(params[:q])
      title_or_search_conf_cont: words
      )
      #id が同じ Request は1件にまとめられる
      @requests = @q.result(distinct: true)
      .where(status: [:approved, :succeeded?]).active.order(updated_at: :desc)
      #.active.where("deadline_at >= ?", Time.current)
    else
      #空で渡す
      @q = Request.ransack({})
      @requests = @q.result(distinct: true)
      .where(status: [:approved, :succeeded?]).active.order(updated_at: :desc)
        #.active.where("deadline_at >= ?", Time.current)
    end
  end

  def new
    @request = Request.new
    @portfolio = Portfolio.find(params[:portfolio_id])
  end

  def create
    @request = current_user.requests.build(request_params)
    @portfolio = Portfolio.find(params[:portfolio_id])
    @creator = @portfolio.user
    @request.creator = @creator
    if @request.save
        @request.submit! if params[:commit] == "send"
        redirect_to current_user
    else
      flash.now[:alert] = "作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @request = Request.find(params[:id])
    #Support_history.new(request: @request)と同じ意味
    @support_history = @request.support_histories.build
    
    @rewards = @request.rewards

    #支援者履歴テーブルからこのリクエストのレコードだけ
    #user_idごとの合計amount順に
    @top_supporters = User
  .joins(:support_histories)
  .where(support_histories: { request_id: @request.id })
  .group("users.id")
  .select("users.*, SUM(support_histories.amount) AS total_amount")
  .order("total_amount DESC")
  .limit(3)
  end

  def edit

  end

  def update
   # ActiveStorage_Attachmentsテーブルのnameがrequest_imagesでidが送られてきたidのレコードに絞り込む。それに一つ一つpurge
    @request.request_images
            .where(id: params[:remove_image_ids])
            .each(&:purge)
#送られてくるのはチェックしたもの
    @request.update!(request_params.except(:request_images)) if @request.request_images.attached?
    @request.update!(request_params) unless @request.request_images.attached?
    redirect_to dashboard_requests_path, notice: "更新に成功しました"
    
  end

  def destroy
    #リクエストを取得
    @request = Request.find(params[:id])
    @request.destroy
  end

private

  def set_request
    @request = Request.find(params[:id])
  end
  #終了しているリクエストには入金ページを表示できない
  #statusがapproved、succeeded?でないのと期限外であるもの
  def authorize_publish!
    if @request.deadline_at.present? && @request.deadline_at < Time.current.floor
      redirect_to current_user, alert: "このリクエストは終了しています"
    end
  end
  #approvedとsucceeded以外のリクエストは入金ページを表示できない
  def authorize_approved_or_succeeded!
    unless @request.approved? || @request.succeeded?
      redirect_to current_user, alert: "このリクエストは非公開です"
    end
  end

  #操作しているのが依頼者でない場合弾く
  def authorize_user!
    @user = @request.user
    raise ActiveRecord::RecordNotFound unless @user == current_user
  end

  #操作しているのがクリエーターでない場合弾く
  def authorize_creator!
    @creator = @request.creator
    raise ActiveRecord::RecordNotFound unless @creator == current_user
  end
  
  #送信済みのリクエストは編集できませんと表示させるため
  def ensure_draft!
    return if @request.draft?
    redirect_to request_path(@request),
    alert: "送信済みのリクエストは編集できません"
  end

  def request_params
    params.require(:request).permit(:title, :body, :target_amount, request_images: [])
  end
end
 