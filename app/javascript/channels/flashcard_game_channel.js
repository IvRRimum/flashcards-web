//= require jquery
import consumer from "channels/consumer"



$(document).ready(function() {
  if ($("#flashcard_game_category_id").length) {
    var flashcard_game_category_id = $("#flashcard_game_category_id").html();
    var flashcard;
    var flashcardState = "new";
    var timeThinkingForAnswer;
    var answerResponseTime;
    var winStreak = {value: 0};

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

    // On winstreak change update the winstreak progress bar
    var winStreakProxy = new Proxy(winStreak, {
      set: function (target, key, value) {
        target[key] = value;

        $("#winstreak-progress-bar").css('width', value+'%').attr('aria-valuenow', value);
        if (value == 10 || 
          value == 20 || 
          value == 30 || 
          value == 40 || 
          value == 50 || 
          value == 60 || 
          value == 70 || 
          value == 80 || 
          value == 90) {
          $("#winstreak-progress-bar").addClass("bg-success");
          $("#winstreak-progress-bar").removeClass("bg-warning");
          $(".max-win-streak-acheaved").addClass("d-none");
          $(".max-win-streak-acheaved").removeClass("d-inline");

          $(".streak-delimiter[data-val='"+value+"'] .progressVal").addClass("d-none");
          $(".streak-delimiter[data-val='"+value+"'] .progress-ico").removeClass("d-none");
          $(".streak-delimiter[data-val='"+value+"']").removeClass("text-muted");
          $(".streak-delimiter[data-val='"+value+"']").addClass("text-warning");
          confetti({
            spread: 180,
            particleCount: value*3,
            gravity: 3,
          });
        } else if (value == 100) {
          confetti({
            spread: 180,
            particleCount: value*3,
            gravity: 3,
          });
          $("#winstreak-progress-bar").removeClass("bg-success");
          $("#winstreak-progress-bar").addClass("bg-warning");
          $(".max-win-streak-acheaved").removeClass("d-none");
          $(".max-win-streak-acheaved").addClass("d-inline");
        } else if (value == 0) {
          $("#winstreak-progress-bar").addClass("bg-success");
          $("#winstreak-progress-bar").removeClass("bg-warning");
          $(".max-win-streak-acheaved").addClass("d-none");
          $(".max-win-streak-acheaved").removeClass("d-inline");

          $(".streak-delimiter .progressVal").removeClass("d-none");
          $(".streak-delimiter .progress-ico").addClass("d-none");
          $(".streak-delimiter").addClass("text-muted");
          $(".streak-delimiter").removeClass("text-warning");
        }

        return true;
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
        if (correct) {
          if (winStreakProxy.value == 100) {
            winStreakProxy.value = 0;
          } else {
            winStreakProxy.value += 2;
          }
        } else {
          winStreakProxy.value = 0;
        }

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
