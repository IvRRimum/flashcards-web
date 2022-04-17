# == Schema Information
#
# Table name: flashcard_answers
#
#  id                    :bigint           not null, primary key
#  answer_response_time  :integer
#  correct               :boolean
#  fc_type               :text
#  thinking_time         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  flashcard_category_id :integer
#  flashcard_id          :integer
#
require "test_helper"

class FlashcardAnswerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
