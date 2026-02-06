class Notification < ApplicationRecord
  #after_createはinsertされた時点で呼び出す(after_create、DBに保存処理　通過前)
  #after_create_commitはDBに保存が確定した時に呼び出される
after_create_commit :broadcast_notification
belongs_to :receiver, class_name: "User"
#belongs_to :sender, class_name: "User" #not_null つけてない
belongs_to :request
#公開された　　成功した　成功して終了した　失敗して終了した　お金が引かれた
enum action: { submit:0, approved:1, succeeded:2, success_finished:3, failed_finished:4, paid:5, art_published:6 }

  def checked!
    raise "invalid state" if self.checked
    update!(checked: true)
  end
end

def broadcast_notification
  # 作成したreceiverカラムに紐づくユーザーが表示している画面のid="notification_bell"を持った要素をnotifications/_bell.html.erbの内容に置き換え
  broadcast_update_to(
  receiver,
  target: "notification_bell",
  partial: "notifications/notification_bell",
  locals: { unchecked_count: receiver.received_notifications.where(checked: false).count }
)
end
