class SupportHistory < ApplicationRecord
  belongs_to :user
  belongs_to :request
  belongs_to :reward
  before_create :set_amount_from_reward

  attribute :shipping_status, :integer

  # 0: 仮押さえ中, 1: 支払い完了, 2: キャンセル済み, 3: 決済失敗
  enum :status, { authorized: 0, paid: 1, canceled: 2, failed: 3 }

  # 都道府県
  enum :shipping_prefecture, {
    hokkaido: 1, aomori: 2, iwate: 3, miyagi: 4, akita: 5, yamagata: 6, fukushima: 7,
    ibaraki: 8, tochigi: 9, gunma: 10, saitama: 11, chiba: 12, tokyo: 13, kanagawa: 14,
    niigata: 15, toyama: 16, ishikawa: 17, fukui: 18, yamanashi: 19, nagano: 20,
    gifu: 21, shizuoka: 22, aichi: 23, mie: 24, shiga: 25, kyoto: 26, osaka: 27, hyogo: 28,
    nara: 29, wakayama: 30, tottori: 31, shimane: 32, okayama: 33, hiroshima: 34, yamaguchi: 35,
    tokushima: 36, kagawa: 37, ehime: 38, kochi: 39, fukuoka: 40, saga: 41, nagasaki: 42,
    kumamoto: 43, oita: 44, miyazaki: 45, kagoshima: 46, okinawa: 47
  }

 # 0: 準備中, 1: 発送済み 2: 発送不要 3: 到着
 enum :shipping_status, {
  preparing: 0,
  shipped: 1,
  not_required: 2,
  arrived: 3
}


# validates :shipping_status, inclusion: { in: SupportHistory.shipping_statuses.keys }

with_options if: :needs_shipping? do
  validates :shipping_prefecture, inclusion: { in: SupportHistory.shipping_prefectures.keys }, presence: true
  validates :shipping_city, :shipping_postal_code, :shipping_address_line1, :shipping_phone_number, presence: true
end

  private

  def set_amount_from_reward
    self.amount = reward.amount
  end

  def needs_shipping?
    reward&.has_shipping?
  end
end
