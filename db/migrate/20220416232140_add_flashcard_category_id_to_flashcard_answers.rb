class AddFlashcardCategoryIdToFlashcardAnswers < ActiveRecord::Migration[7.0]
  def change
    add_column :flashcard_answers, :flashcard_category_id, :integer
  end
end
