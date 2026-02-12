class Requests::RewardsController < ApplicationController
  
  def new
    @request = Request.find(params[:request_id])
    #これで作られたRewardレコードの個数分、fields_forが
    #{"rewards_attributes" => { "0" => { "title" => "" }}を生成
    @request.rewards.build
  end

end
