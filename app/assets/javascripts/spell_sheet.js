

$(document).ready(function() {

  $("#spellsheet").on("mouseenter", ".memorization_spell", function() {
    $(this).find(".spell_controls").show();
  });

  $("#spellsheet").on("mouseleave", ".memorization_spell", function() {
    $(this).find(".spell_controls").hide();
  });
});