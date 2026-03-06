# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
   def create
    # emailからユーザーを探す　トークン発行　送信
    self.resource = resource_class.send_confirmation_instructions(resource_params)

    
    # 送信処理がうまく行ったか
    if successfully_sent?(resource)
      session.delete(:registered_email)
      flash.now[:notice] = "確認メールを再送しました。"
      #書き換え対象はid=flash 中身はshared/flash_messages
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")

    else
      flash.now[:alert] = "エラーが発生しました。恐れ入りますが運営にお問い合わせください。"
      #書き換え対象はid=flash 中身はshared/flash_messages
      render turbo_stream: turbo_stream.update("flash", partial: "shared/flash_messages")
    end
  #   super
   end

  # GET /resource/confirmation?confirmation_token=abcdef
   def show
    # トークンが同じユーザーを探し　認証済み等のチェック後　confirmed_atに現在時刻を入れる
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    #　有効時間内に認証が完了した場合
    if resource.errors.empty?

    # セッションの作成
      sign_in(resource) 
      redirect_to root_path, notice: "メール認証が完了し、ログインしました！"
    else
    # 既に認証済みemailの（already_confirmed）というエラーが含まれているかチェック
    # エラーのメモ帳（errors オブジェクト）には、モデルの属性名（カラム名）がそのまま「見出し」として存在 emailのalready_confirmed
    # すでに認証済み 
      if resource.errors.added? :email, :already_confirmed
        redirect_to root_path, alert: "既に認証済みです"
      else
        # それ以外のエラー（期限切れなど）は、通常の再送画面を表示
        render :new, status: :unprocessable_entity
      end
  #   super
   end
  end
  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
