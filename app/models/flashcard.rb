# == Schema Information
#
# Table name: flashcards
#
#  id                    :bigint           not null, primary key
#  english               :text
#  hanzi                 :text
#  pinyin                :text
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
end
