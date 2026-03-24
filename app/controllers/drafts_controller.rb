class DraftsController < ApplicationController
  def index
    @requests = current_user.requests.draft
  end

  def show
    @request = Request.with_attached_request_images.find(params[:id])
  end
end
