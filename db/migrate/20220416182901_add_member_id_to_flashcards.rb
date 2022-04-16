class AddMemberIdToFlashcards < ActiveRecord::Migration[7.0]
  def change
    add_column :flashcards, :member_id, :integer
  end
end
