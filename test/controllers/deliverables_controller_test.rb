require "test_helper"

class DeliverablesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get deliverables_new_url
    assert_response :success
  end

  test "should get create" do
    get deliverables_create_url
    assert_response :success
  end
end
