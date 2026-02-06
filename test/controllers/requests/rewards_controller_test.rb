require "test_helper"

class Requests::RewardsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get requests_rewards_new_url
    assert_response :success
  end

  test "should get create" do
    get requests_rewards_create_url
    assert_response :success
  end
end
