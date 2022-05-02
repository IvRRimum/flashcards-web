class AddPinyinTransliterated < ActiveRecord::Migration[7.0]
  def up
    add_column :flashcards, :pinyin_transliterated, :text
  end

  def down
    remove_column :flashcards, :pinyin_transliterated
  end
end
