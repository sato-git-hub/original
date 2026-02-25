require "test_helper"

class CreatorSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get creator_settings_new_url
    assert_response :success
  end

  test "should get index" do
    get creator_settings_index_url
    assert_response :success
  end

  test "should get edit" do
    get creator_settings_edit_url
    assert_response :success
  end

  test "should get show" do
    get creator_settings_show_url
    assert_response :success
  end
end
