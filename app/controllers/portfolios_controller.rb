class PortfoliosController < ApplicationController
  def index

    base_query = CreatorSetting.where(published: true)
    search_params = params[:q] || {}
    if search_params[:user_id_cont].present?
      words = search_params[:user_id_cont].split(/[[:space:]]+/)
      @q = base_query.ransack(user_id_cont: words)
    else
      @q = base_query.ransack(search_params)
    end
    #クエリ　ユーザーidと紐付けた画像
    @portfolios = @q.result
    #以下ではリクエストが複数画像を持っている場合関係テーブルが膨らむのではないか
    .with_attached_images
    #@q.resultで条件絞り込んだcreator_settingオブジェクトを取得　#user_id等が含まれる
    #user_idからbelong_to userによりuser_idの参照ユーザーオブジェクト
    #ここをincludesにするとuserが複数画像をavatarを持っていた場合に関係テーブルが膨らむ　今回はユーザーとアバターが1対１なのでincludesにすることでeager_loadになり　userとその画像が一度のクエリで取得できるので問題ない
    .preload(user: { avatar_attachment: :blob })
  end
end