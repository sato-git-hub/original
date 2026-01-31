class CloseProjectJob < ApplicationJob
  queue_as :default

  def perform(request)
    #空、終了してたら抜ける
    return if request.nil? || request.finished? || request.success_finished?
    return if Time.current.floor < request.deadline_at
    # 期間が過ぎた時にどっちになるか判定
    request.finish_if_expired!

    request.support_histories.authorized.each do |support_history|

    charge = Payjp::Charge.retrieve(support_history.payjp_charge_id)

    charge.capture

    support_history.update!(status: :paid)
    end
  end
end