# == Schema Information
#
# Table name: flashcards
#
#  id                    :bigint           not null, primary key
#  english               :text
#  hanzi                 :text
#  pinyin                :text
#  pinyin_transliterated :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  flashcard_category_id :bigint
#  member_id             :integer
#
# Indexes
#
#  index_flashcards_on_flashcard_category_id  (flashcard_category_id)
#
class Flashcard < ApplicationRecord
  belongs_to :member
  belongs_to :flashcard_category
  has_many :flashcard_answers, dependent: :destroy

  def self.select_answer_count
    joins(:flashcard_answers).
      select("count(flashcard_answers.id) as answer_count")
  end

  def self.select_wrong_answer_count
    joins(:flashcard_answers).
      select("count(flashcard_answers.correct) filter (where flashcard_answers.correct = false) as wrong_answer_count")
  end

  # Can only be called after select_wrong_answer_count and select_answer_count
  def wrong_answer_percentage
    return 100 if !defined?(answer_count) || !defined?(wrong_answer_count)
    (wrong_answer_count.to_f / answer_count.to_f * 100).to_i
  end
end
