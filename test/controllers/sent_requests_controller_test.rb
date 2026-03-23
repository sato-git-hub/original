require "test_helper"

class SentRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sent_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get sent_requests_show_url
    assert_response :success
  end
end
