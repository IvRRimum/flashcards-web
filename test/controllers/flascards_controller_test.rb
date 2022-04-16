require "test_helper"

class FlascardsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get flascards_new_url
    assert_response :success
  end

  test "should get create" do
    get flascards_create_url
    assert_response :success
  end

  test "should get edit" do
    get flascards_edit_url
    assert_response :success
  end

  test "should get update" do
    get flascards_update_url
    assert_response :success
  end

  test "should get delete" do
    get flascards_delete_url
    assert_response :success
  end
end
