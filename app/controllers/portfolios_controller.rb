class PortfoliosController < ApplicationController
  before_action :portfolio_set!, only: [ :show ]
  before_action :authorize_portfolio!, only: [ :edit, :update ]
  before_action :redirect_if_portfolio_exists, only: [ :new, :create ]
  before_action :redirect_unless_portfolio_exists, only: [ :edit ]
  def index
    @portfolios = Portfolio.where(published: true)
  end
  def new
    @portfolio = Portfolio.new
  end

  def create
    @portfolio = current_user.build_portfolio(portfolio_params)
    if @portfolio.save
      redirect_to current_user, notice: "ポートフォリオを作成しました"
    else
      flash.now[:alert] = "ポートフォリオの作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @creator = @portfolio.user
  end

  def edit
    @portfolio = current_user.portfolio
  end

  def update
    ActiveRecord::Base.transaction do

      @portfolio = current_user.portfolio
      if params[:remove_image_ids].present?
        attachments = @portfolio.images.where(id: params[:remove_image_ids])
        if @portfolio.images.attachments.count - attachments.count <= 0
          raise StandardError, "画像は少なくとも1枚必要です"
        end
        attachments.each(&:purge)
      end

      @portfolio.update!(portfolio_params.except(:images))

      if portfolio_params[:images].present?
          @portfolio.images.attach(portfolio_params[:images]) 
      end

    end

    redirect_to @portfolio, notice: "ポートフォリオを更新しました"

  rescue => e
    flash.now[:alert] = e.message
    render :edit, status: :unprocessable_entity
  end



  private

  def portfolio_set!
       @portfolio = Portfolio.find(params[:id])
  end

  def authorize_portfolio!
      portfolio = Portfolio.find(params[:id])
      raise ActiveRecord::RecordNotFound unless portfolio.user == current_user
  end

  def redirect_if_portfolio_exists
    redirect_to edit_portfolio_path(current_user.portfolio), alert: "ポートフォリオはすでに作成されています" if current_user.portfolio
  end

  def redirect_unless_portfolio_exists
    redirect_to new_portfolio_path, alert: "先にポートフォリオを作成してください" unless current_user.portfolio
  end

  def portfolio_params
    params.require(:portfolio).permit(:title, :body, :published, images: [])
  end
end
