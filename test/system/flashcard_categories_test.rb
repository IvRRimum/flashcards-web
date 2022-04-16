require "application_system_test_case"

class FlashcardCategoriesTest < ApplicationSystemTestCase
  setup do
    @flashcard_category = flashcard_categories(:one)
  end

  test "visiting the index" do
    visit flashcard_categories_url
    assert_selector "h1", text: "Flashcard categories"
  end

  test "should create flashcard category" do
    visit flashcard_categories_url
    click_on "New flashcard category"

    fill_in "Note", with: @flashcard_category.note
    fill_in "Title", with: @flashcard_category.title
    click_on "Create Flashcard category"

    assert_text "Flashcard category was successfully created"
    click_on "Back"
  end

  test "should update Flashcard category" do
    visit flashcard_category_url(@flashcard_category)
    click_on "Edit this flashcard category", match: :first

    fill_in "Note", with: @flashcard_category.note
    fill_in "Title", with: @flashcard_category.title
    click_on "Update Flashcard category"

    assert_text "Flashcard category was successfully updated"
    click_on "Back"
  end

  test "should destroy Flashcard category" do
    visit flashcard_category_url(@flashcard_category)
    click_on "Destroy this flashcard category", match: :first

    assert_text "Flashcard category was successfully destroyed"
  end
end
