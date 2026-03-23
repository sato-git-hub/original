require "test_helper"

class SupportedRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get supported_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get supported_requests_show_url
    assert_response :success
  end
end
