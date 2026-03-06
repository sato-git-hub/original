class ProjectMailer < ApplicationMailer
  default from: "notifications@example.com" # 送信元アドレス

  def success_notification(request)
    @request = request
    @user = request.creator
    mail(
      to: @user.email,
      subject: "【重要】プロジェクト達成おめでとうございます！支援金確定のお知らせ"
    )
  end
end
