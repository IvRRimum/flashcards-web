# == Schema Information
#
# Table name: flashcard_categories
#
#  id         :bigint           not null, primary key
#  note       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  member_id  :integer
#
class FlashcardCategory < ApplicationRecord
  belongs_to :member
  has_many :flashcards, dependent: :destroy
  has_many :flashcard_answers, dependent: :destroy
end
