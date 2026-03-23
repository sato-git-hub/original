require "test_helper"

class DraftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get drafts_index_url
    assert_response :success
  end

  test "should get show" do
    get drafts_show_url
    assert_response :success
  end
end
