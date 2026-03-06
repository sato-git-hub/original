class ContactsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  def new
    
  end

  def create
    contact_params = params.permit(:name, :email, :content)

    ContactMailer.send_mail(contact_params).deliver_later
  
    if user_signed_in?
      redirect_to root_path, notice: "お問い合わせを送信しました。"
    else
      # ログインしていない人はログインページへ
      redirect_to new_user_session_path, notice: "お問い合わせを送信しました。"
    end
  end
end
