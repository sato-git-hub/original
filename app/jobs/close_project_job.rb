class CloseProjectJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    request = Request.find(request_id)
    # approved、success以外は抜ける
    raise RuntimeError, "Invalid request state" unless request.approved? || request.success?
    raise RuntimeError, "Deadline has not passed" if Time.current.floor < request.deadline_at

    # 期間が過ぎた時にどっちになるか判定
    request.finish_if_expired!
    if request.success_finished?
      request.notifications.create!(receiver: request.user, action: :success_finished)
      request.support_histories.authorized.find_each do |support_history|
        begin
          charge = Payjp::Charge.retrieve(support_history.payjp_charge_id)
          unless charge.captured
            charge.capture
          end
          support_history.update!(status: :paid)
          request.notifications.create!(receiver: support_history.user, action: :paid)
        # Payjp::Charge.retrieveまたはcharge.captureで失敗 => リトライ。statusはauthorizedのまま
        rescue Payjp::PayjpError => e
          #e.json_body[:error][:code]rescue nil この処理自体を失敗した時にnilを代入
          error_code = e.json_body.dig(:error, :code)
          if error_code == 'already_captured'
            support_history.update!(status: :paid)
          elsif ['card_declined', 'expired_card'].include?(error_code)
            # 【個人的失敗】カード側の問題。リトライしても無駄なので、failedにして次の支援者へ
            support_history.update!(status: :failed)
            Rails.logger.error "決済不能 [ID: #{support_history.id}]: #{e.message}"
          else
            # 【一時的失敗】ネットワークエラー等。Jobをリトライさせたいので raise する
            # これにより、Jobマネージャーが「失敗」と検知して後でやり直してくれる
            Rails.logger.error "決済失敗 [ID: #{support_history.id}]: #{e.message}"
            raise e
          end
        end
      end
    else #request.finished?
      request.notifications.create!(receiver: request.user, action: :failed_finished)
      request.support_histories.authorized.find_each do |support_history|
        begin
          charge = Payjp::Charge.retrieve(support_history.payjp_charge_id)
          unless charge.refunded
            charge.refund
          end
          support_history.update!(status: :canceled)
        rescue Payjp::PayjpError => e
          #e.json_body[:error][:code]rescue nil この処理自体を失敗した時にnilを代入
          error_code = e.json_body.dig(:error, :code)
          if error_code == 'already_refunded'
            support_history.update!(status: :canceled)
          else
            Rails.logger.error "返金失敗 [ID: #{support_history.id}]: #{e.message}"
            raise e
          end
        end
      end
    end
  end
end