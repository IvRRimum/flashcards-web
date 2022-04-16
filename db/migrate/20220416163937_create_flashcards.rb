class CreateFlashcards < ActiveRecord::Migration[7.0]
  def change
    create_table :flashcards do |t|
      t.belongs_to :flashcard_category, index: true
      t.string :fl_type
      t.text :pinyin
      t.text :hanzi
      t.text :english
      t.boolean :correct
      t.integer :thinking_time
      t.integer :answer_response_time

      t.timestamps
    end
  end
end
