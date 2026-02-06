class Requests::RewardsController < ApplicationController
  def new
    @reward = Reward.new
  end

  def create
    

  end

private
  def reward_params
    params.require(:reward).permit(:title, :body, :amount, :stock)
  end
end
