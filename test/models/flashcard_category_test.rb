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
require "test_helper"

class FlashcardCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
