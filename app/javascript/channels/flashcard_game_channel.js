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
          $("#spinner").addClass("d-none");
          flashcardState = "thinking";
          flashcard = data["flashcard"];
          timeThinkingForAnswer = new Date().getTime();
          $("#english").html(data["flashcard"]["english"]);
        } else if (data["action"] == "can_start_next_flashcard") {
          this.perform("new_flashcard", {flashcard_game_category_id: flashcard_game_category_id});
        }
      }
    });

    // On clicking the flashcards
    $("#flashcard").click(() => {flashcardsClick();});

    function flashcardsClick() {
      if (flashcardState == "thinking") {
        timeThinkingForAnswer = new Date().getTime() - timeThinkingForAnswer;
        answerResponseTime = new Date().getTime();
        flashcardState = "waiting_for_answer";
        $("#pinyin").html(flashcard["pinyin"]);
        $("#hanzi").html(flashcard["hanzi"]);
        $("#answer_response").removeClass("d-none");
        $("#flashcard").removeClass("cursor-pointer");
      }
    }

    // On clicking thumbs up/down
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
        $("#spinner").removeClass("d-none");
        flashcardGameChannel.perform("save_flashcard_answer", {
          thinking_time: timeThinkingForAnswer, 
          answer_response_time: answerResponseTime,
          correct: correct
        });
      }
    };

    // Keyboard shortcuts
    $(document).on('keypress',function(e) {
      if(e.which == 32) {
        flashcardsClick();
      } else if (e.which == 110) {
        SaveFlashcardAnswer(true);
      } else if (e.which == 109) {
        SaveFlashcardAnswer(false);
      }
      e.preventDefault();
    });
  };
});


