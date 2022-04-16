class CreateFlashcardCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :flashcard_categories do |t|
      t.string :title
      t.text :note

      t.timestamps
    end
  end
end
