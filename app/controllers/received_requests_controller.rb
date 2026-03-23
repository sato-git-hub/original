class ReceivedRequestsController < ApplicationController
  def index
    @status = params[:status] || "submit"
    unless Request.statuses.keys.include?(@status)
      @status = "submit"
    end
    #　最初に作成のが新しい順
    @requests = current_user
                  .received_requests
                  .preload(:support_histories, user: { avatar_attachment: :blob })
                  .where(status: @status)
  end

  def show
    @request = Request
                .with_attached_request_images
                .preload(:support_histories, user: { avatar_attachment: :blob }) 
                .find(params[:id])
  end
end
