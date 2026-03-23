class DeliverablesController < ApplicationController

  def update
    @request = current_user.received_requests.find(params[:request_id])
    
    @request.complete!(deliverable_params)
    Rails.logger.debug "=======================成功#{ @request.inspect }================================="
      redirect_to received_requests_path, notice: "納品が完了しました"
    rescue => e
      flash[:alert] = e.message
      Rails.logger.debug "=======================失敗#{ @request.inspect }================================="
      redirect_to root_path
  end

  def index
    @requests = current_user
    .received_requests
    .success_finished
    .active_deadline
    .with_attached_request_images
    .order(:delivery_due_date)
  end

  def download
    file = 
   #send_data file.download,
           # filename: file.filename.to_s,
            #type: file.content_type,
            #disposition: "attachment"

            redirect_to rails_blob_path(current_user.avatar, disposition: "attachment")
  end

  private
  def deliverable_params
    params.require(:request).permit(:deliverable, :deliverable_psd)
  end
end
