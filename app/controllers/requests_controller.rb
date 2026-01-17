class RequestsController < ApplicationController
  def index
    #全てのリクエストを一覧
    @requests = Request.all

  end

  def new
    @request = Request.new
    @creator = User.find(params[:user_id])
  end

  def create

    @request = current_user.requests.build(request_params) #今ログインしているユーザーのuser_idが入ったrequestsレコード
    @creator = User.find(params[:user_id])
    # requestモデルに定義した belongs_to :creator,   class_name: "User"　creator(中身はUserオブジェクト)に@creator(中身はUserオブジェクト)を代入
    @request.creator = @creator #イラストレーターのポートフォリオを押すと、creator_idにそのイラストレーターのuser.idが保存されるように
    if @request.save
      redirect_to current_user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  #urlのuser_idの作ったリクエストの中からurlのidのリクエスト
  @request = Request.find(params[:id])
  end
private
  def request_params
    params.require(:request).permit(:title, :body, request_images: [])
  end
end
