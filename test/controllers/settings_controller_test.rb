require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get settings_new_url
    assert_response :success
  end

  test "should get create" do
    get settings_create_url
    assert_response :success
  end
end
