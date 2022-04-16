require "test_helper"

class FlashcardCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flashcard_category = flashcard_categories(:one)
  end

  test "should get index" do
    get flashcard_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_flashcard_category_url
    assert_response :success
  end

  test "should create flashcard_category" do
    assert_difference("FlashcardCategory.count") do
      post flashcard_categories_url, params: { flashcard_category: { note: @flashcard_category.note, title: @flashcard_category.title } }
    end

    assert_redirected_to flashcard_category_url(FlashcardCategory.last)
  end

  test "should show flashcard_category" do
    get flashcard_category_url(@flashcard_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_flashcard_category_url(@flashcard_category)
    assert_response :success
  end

  test "should update flashcard_category" do
    patch flashcard_category_url(@flashcard_category), params: { flashcard_category: { note: @flashcard_category.note, title: @flashcard_category.title } }
    assert_redirected_to flashcard_category_url(@flashcard_category)
  end

  test "should destroy flashcard_category" do
    assert_difference("FlashcardCategory.count", -1) do
      delete flashcard_category_url(@flashcard_category)
    end

    assert_redirected_to flashcard_categories_url
  end
end
