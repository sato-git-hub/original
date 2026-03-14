class DeliverablesController < ApplicationController
  def new
    # @request = Request.find(params[:request_id])
    # フォーム　model:@request
    #
  end

  def create

  end

  def index
    #@requests = current_user.received_requests.success_finished
    @requests = current_user.received_requests
  end

  private
  def deliverable_params
    params.require(:request).permit(deliverable: [])
  end
end
