// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
//= require jquery_ujs
//= require bootstrap
import "channels"

// store the currently selected tab in the hash value
$(document).ready(function() {
  $("button[data-bs-toggle='tab']").click(function(e) {
    var id = $(e.target).attr("data-bs-target").substr(1);
    window.location.hash = id;
  });

  // on load of the page: switch to the currently selected tab
  var hash = window.location.hash;
  console.log(hash);
  $('#nav-tab button[data-bs-target="' + hash + '"]').tab('show');
});
