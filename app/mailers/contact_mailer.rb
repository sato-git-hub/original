class ContactMailer < ApplicationMailer
  def send_mail(contact_params)
    @name = contact_params[:name]
    @email = contact_params[:email]
    @content = contact_params[:content]
    
    mail(
      to: ENV["CONTACT_EMAIL"],
      subject: "【お問い合わせ】ユーザーからのメッセージ",
      reply_to: @email
    )
  end
end
