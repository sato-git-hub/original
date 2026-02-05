class Notification < ApplicationRecord
  #after_createはinsertされた時点で呼び出す(after_create、DBに保存処理　通過前)
  #after_create_commitはDBに保存が確定した時に呼び出される
after_create_commit :broadcast_notification
belongs_to :receiver, class_name: "User"
#belongs_to :sender, class_name: "User" #not_null つけてない
belongs_to :request
#公開された　　成功した　成功して終了した　失敗して終了した　お金が引かれた
enum action: { approved:0, succeeded:1, success_finished:2, failed_finished:3, paid:4, art_published:5 }

  def checked!
    raise "invalid state" if self.checked
    update!(checked: true)
  end
end

def broadcast_notification
  broadcast_replace_to(
  receiver,
  target: "notification_bell",
  partial: "notifications/bell",
  locals: { unchecked_count: receiver.notifications.unchecked.count }
)
end
