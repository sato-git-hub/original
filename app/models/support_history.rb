class SupportHistory < ApplicationRecord
belongs_to :user
belongs_to :request
#0: 仮押さえ中, 1: 支払い完了, 2: キャンセル済み, 3: 決済失敗
enum :status, { authorized: 0, paid: 1, canceled: 2, failed: 3 }
end
