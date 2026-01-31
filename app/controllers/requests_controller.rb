class RequestsController < ApplicationController
  before_action :set_request, only: [:edit, :show, :update]
  before_action :authorize_user!, only: [:update]
  before_action :authorize_publish!, only: [:show]
  before_action :ensure_draft!, only: [:edit, :update]

  # 受け取ったリクエスト一覧
  def incoming
  # クリエーターとして関わるリクエスト #requestモデルにて received_requestsがrequestsテーブルのcreator_id == current_user.id
    @requests = current_user.received_requests.submit.order(updated_at: :desc)
  end

  def dashboard
      @q = Request.ransack(params[:q])
      # Request.where(status: 1)
      @requests = @q.result.where(user: current_user)
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
      .where(status: [:approved, :successed]).active.order(updated_at: :desc)
      #.active.where("deadline_at >= ?", Time.current)
    else
      #空で渡す
      @q = Request.ransack({})
      @requests = @q.result(distinct: true)
      .where(status: [:approved, :successed]).active.order(updated_at: :desc)
        #.active.where("deadline_at >= ?", Time.current)
    end
  end

  def new
    @request = Request.new
    @request.build_character
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
  end

  def edit

  end

  def update
    if @request.update(request_params)
      #flash[:notice] = "成功しました！"とおなじ
      redirect_to dashboard_requests_path, notice: "更新に成功しました"
    else
      render :edit, flash.now[:alert] = "操作の更新に失敗しました"
    end
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
  #statusがapproved、successedでないのと期限外であるもの
  def authorize_publish!
    unless (@request.approved? || @request.successed?) && @request.deadline_at >= Time.current.floor
      redirect_to dashboard_requests_path, alert: "このリクエストは終了しています"
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
    params.require(:request).permit(:title, :body, :target_amount, :lowest_amount, request_images: [],
    character_attributes: [
      :hair_color, :hair_style, :hair_type, :hair_length, :skin_tone, :height, :body_type, 
      :body_frame, :personal_color, :age, :sex, :eye_color, :glasses,
      :eye_shape, :face_type, :face_shape, :mbti, :bang_style
    ])
  end
end
 