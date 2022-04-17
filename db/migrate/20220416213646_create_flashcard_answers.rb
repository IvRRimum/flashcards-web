class CreateFlashcardAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :flashcard_answers do |t|
      t.integer :flashcard_id
      t.text :fc_type
      t.boolean :correct
      t.integer :thinking_time
      t.integer :answer_response_time

      t.timestamps
    end
  end
end
