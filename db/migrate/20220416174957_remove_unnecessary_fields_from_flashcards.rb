class RemoveUnnecessaryFieldsFromFlashcards < ActiveRecord::Migration[7.0]
  def change
    remove_column :flashcards, :answer_response_time
    remove_column :flashcards, :correct
    remove_column :flashcards, :fl_type
    remove_column :flashcards, :thinking_time
  end
end
