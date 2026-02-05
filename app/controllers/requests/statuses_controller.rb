class Requests::StatusesController < ApplicationController
  before_action :set_request, only: [ :submit, :decline, :approve ]
  before_action :authorize_user!, only: [ :submit ]
  before_action :authorize_creator!, only: [ :approve ]

    # draft → submit
    def submit
      
      @request.submit!
      redirect_to dashboard_requests_path, notice: "リクエストの公開が開始されました"
      
      rescue => e
        redirect_to @user, alert: "処理に失敗しました"
    end
    
    # submit → approved
    def approve
      begin #省略可
        
        @request.approve!
        redirect_to incoming_requests_path, notice: "リクエストの公開が開始されました"
    
      rescue => e
        Rails.logger.debug "DEBUG: keyword=#{e.message}"
        redirect_to @creator, alert: "処理に失敗しました"
      end
    end
 
    # → creator_declined
    def decline
      
      @request.decline!
      redirect_to incoming_requests_path
     
      rescue => e
        redirect_to current_user, alert: "処理に失敗しました"
    end

  private

  def set_request
    @request = Request.find(params[:request_id])
  end

  # 操作しているのが依頼者でない場合弾く
  def authorize_user!
    @user = @request.user
    raise ActiveRecord::RecordNotFound unless @user == current_user
  end

  # 操作しているのがクリエーターでない場合弾く
  def authorize_creator!
    @creator = @request.creator
    raise ActiveRecord::RecordNotFound unless @creator == current_user
  end
end