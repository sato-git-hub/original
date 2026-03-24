class CancelRequestJob < ApplicationJob
  queue_as :default

  def perform
    expired_requests =
    Request
      .where(status: :success_finished)
      .where("delivery_due_date < ?", Time.current.floor)

    count = expired_requests.count

    expired_requests.update_all(status: :expired)

    Rails.logger.info "Expired #{count} requests"

  end
end


