class AddMemberIdToFlashcardCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :flashcard_categories, :member_id, :integer
  end
end
