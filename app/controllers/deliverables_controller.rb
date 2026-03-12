class DeliverablesController < ApplicationController
  def new
    # @request = Request.find(params[:request_id])
    # フォーム　model:@request
    #
  end

  def create

  end

  private
  def deliverable_params
    params.require(:request).permit(deliverable: [])
  end
end
