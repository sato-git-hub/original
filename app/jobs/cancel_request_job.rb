class CancelRequestJob < ApplicationJob
  queue_as :default

  def perform(request_id)
    Request
      .where(status: :success_finished)
      .where("delivery_deadline < ?", Time.current.floor)
      .find_each do |request|
        request.update!(status: :expired)
      end
  end
end
