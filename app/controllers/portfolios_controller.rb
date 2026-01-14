class PortfoliosController < ApplicationController
  before_action :authorize_portfolio_owner!, except:[:show]
  before_action :portfolio_created!, only:[:new, :create]
  before_action :portfolio_new!, only:[:edit, :update]
  def new
    #入れ子にすると/users/:user_id/portfolio/newとなる
    #　idが例えば1のユーザ情報レコードを格納
    @user = User.find(params[:user_id])
    # @portfolio = Portfolio.new(user_id: @user.id)と同じ意味
    @portfolio = @user.build_portfolio
  end

  def create
    @user = User.find(params[:user_id])
    @portfolio = @user.build_portfolio(portfolio_params)
    if @portfolio.save
      redirect_to user_portfolio_path(@user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user =User.find(params[:user_id])
    @portfolio = @user.portfolio
  end

  def edit
    @user = User.find(params[:user_id])
    @portfolio = @user.portfolio
  end

 def update
    @user = User.find(params[:user_id])
    #既存の portfolio があるか確認。あった場合→ 既存 portfolio の user_id を nil にして削除しようとする。そのあと 新しい portfolio を作ろうとする
    #@portfolio = @user.build_portfolio(portfolio_params)
    @portfolio = @user.portfolio
    if @portfolio.update(portfolio_params)
      redirect_to user_portfolio_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
 end

  def destroy
  end

  private 
  def portfolio_created!
    redirect_to edit_user_portfolio_path(current_user) if current_user.portfolio
  end

  def portfolio_new!
    redirect_to new_user_portfolio_path(current_user) unless current_user.portfolio
  end

  def authorize_portfolio_owner!
    @user = User.find(params[:user_id])
    #一致してたらこの関数を抜ける
    return if current_user.id == @user.id
    #一致しない場合 
    redirect_to user_path(current_user)
  end
  
  def portfolio_params
    params.require(:portfolio).permit(:title, :body, :image)
  end
end