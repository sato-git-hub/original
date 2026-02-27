require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get after_registration_confirmation" do
    get static_pages_after_registration_confirmation_url
    assert_response :success
  end
end
