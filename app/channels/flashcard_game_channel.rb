class FlashcardGameChannel < ApplicationCable::Channel

  def subscribed
    stream_from current_member
    @flashcard_answer = FlashcardAnswer.new
  end

  def receive(data)
  end

  def new_flashcard(data)
    flashcard = current_member.flashcard_categories.find(data["flashcard_game_category_id"]).flashcards.order("RANDOM()").first
    @flashcard_answer = FlashcardAnswer.new(
      fc_type: "english",
      flashcard_id: flashcard.id,
      thinking_time: 1,
      flashcard_category: flashcard.flashcard_category
    )

    ActionCable.server.broadcast(current_member, {action: "populate_flashcard", flashcard: flashcard})
  end

  def save_flashcard_answer(data)
    @flashcard_answer.correct = data["correct"]
    @flashcard_answer.thinking_time = data["thinking_time"]
    @flashcard_answer.answer_response_time = data["answer_response_time"]
    @flashcard_answer.save

    ActionCable.server.broadcast(current_member, {action: "can_start_next_flashcard"})
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
