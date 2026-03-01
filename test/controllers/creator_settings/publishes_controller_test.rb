require "test_helper"

class CreatorSettings::PublishesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get creator_settings_publishes_show_url
    assert_response :success
  end
end
