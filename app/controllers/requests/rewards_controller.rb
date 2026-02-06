class Requests::RewardsController < ApplicationController
  
  def new
    @request = Request.find(params[:request_id])
    #これで作られたRewardレコードの個数分、fields_forが
    #{"rewards_attributes" => { "0" => { "title" => "" }}を生成
    2.times { @request.rewards.build }
  end

  def create
  end

private
  def reward_params
    params.require(:reward).permit(:title, :body, :amount, :stock)
  end
end
