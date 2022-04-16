//= require jquery
import consumer from "channels/consumer"



$(document).ready(function() {
  if ($("#flashcard_game_category_id").length) {
    var flashcard_game_category_id = $("#flashcard_game_category_id").html();
    var flashcard;
    var flashcardState = "new";
    var timeThinkingForAnswer;
    var answerResponseTime;

    const flashcardGameChannel = consumer.subscriptions.create("FlashcardGameChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        this.perform("new_flashcard", {flashcard_game_category_id: flashcard_game_category_id});
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        if (data["action"] == "populate_flashcard") {
          flashcardState = "thinking";
          flashcard = data["flashcard"];
          timeThinkingForAnswer = new Date().getTime();
          $("#english").html(data["flashcard"]["english"]);
        } else if (data["action"] == "can_start_next_flashcard") {
          this.perform("new_flashcard", {flashcard_game_category_id: flashcard_game_category_id});
        }
      }
    });

    $("#flashcard").click(function() {
      if (flashcardState == "thinking") {
        timeThinkingForAnswer = new Date().getTime() - timeThinkingForAnswer;
        answerResponseTime = new Date().getTime();
        flashcardState = "waiting_for_answer";
        $("#pinyin").html(flashcard["pinyin"]);
        $("#hanzi").html(flashcard["hanzi"]);
        $("#answer_response").removeClass("d-none");
        $("#flashcard").removeClass("cursor-pointer");
      }
    });

    $("#flashcard_correct").click(() => {SaveFlashcardAnswer(true)});
    $("#flashcard_incorrect").click(() => {SaveFlashcardAnswer(false)});

    function SaveFlashcardAnswer(correct) {
      if (flashcardState == "waiting_for_answer") {
        answerResponseTime = new Date().getTime() - answerResponseTime;
        flashcardState = "done";
        $("#pinyin").html("");
        $("#hanzi").html("&nbsp;");
        $("#answer_response").addClass("d-none");
        $("#flashcard").addClass("cursor-pointer");
        flashcardGameChannel.perform("save_flashcard_answer", {
          thinking_time: timeThinkingForAnswer, 
          answer_response_time: answerResponseTime,
          correct: correct
        });
      }
    }
  };
});


