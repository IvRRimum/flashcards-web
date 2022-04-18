class HomeController < ApplicationController
  def index
    if member_signed_in?
      @todays_worst_performing_flashcards = current_member.
        flashcards.
        joins(:flashcard_answers).
        select("flashcards.*").
        select_answer_count.
        select_wrong_answer_count.
        where(
          flashcard_answers: {
            created_at: (Time.now - 1.day)..Time.now
          }
        ).
        group("flashcards.id").
        order("wrong_answer_count DESC").
        limit(20)
    end
  end
end
