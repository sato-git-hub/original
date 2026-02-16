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
      redirect_to current_user
    else
      render :new, alert: "作成に失敗しました", status: :unprocessable_entity
    end
  end

  def show
    @creator = @portfolio.user
  end

  def edit
    @portfolio = current_user.portfolio
  end

 def update
    @portfolio = current_user.portfolio
    if @portfolio.update(portfolio_params)
      redirect_to current_user
    else
      render :edit, alert: "更新に失敗しました", status: :unprocessable_entity
    end
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
    params.require(:portfolio).permit(:title, :body, images: [])
  end
end
