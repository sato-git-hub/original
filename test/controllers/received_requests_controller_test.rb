require "test_helper"

class ReceivedRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get received_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get received_requests_show_url
    assert_response :success
  end
end
