$(function () {
  $('#open_questions').on("click", "[data-fill-input] a:not([disabled])", function () {
    console.warn("Click on '#open_questions' registered.");
    var $anchor = $(this);
    var value = $anchor.data('fillInputValue');
    if (value === undefined) {
      console.log("data-fill-input-value not defined on this tag.");
    }
    var $input = $anchor.closest("fieldset").find("input");
    $input.val(value);
    $input.closest("form").submit();
  })
})
