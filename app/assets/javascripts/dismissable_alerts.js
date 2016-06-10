$(function () {
  function slideRemainingUp($element, height) {
    $element.nextAll().each(function () {
      var top = parseInt($(this).css("top"));
      $(this).css("top", top - height - 10);
    });
    $element.slideUp().promise().done(function () {
      $(this).remove();
    });
  }

  window.showDismissableAlert = function (text, type, options) {

    if (type === undefined)  type = "warning";
    if (options === undefined)  options = {};
    var $element = $('<div class="alert alert-overlay alert-dismissible alert-' + type + '" role="alert">' +
      '<button type="button" class="close" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
      text +
      '</div>');
    $element.css("visibility", "hidden");
    $("#flashes").prepend($element);
    var height = $element.outerHeight();
    $element.css("visibility", "").hide().slideDown(500);
    $element.nextAll().each(function () {
      var top = parseInt($(this).css("top"));
      if (isNaN(top)) top = 0;
      $(this).css("top", top + height + 10);
    });

    $element.find(".close").on('click', function () {
      slideRemainingUp($element, height);
    });


    if (options.timeout && !isNaN(options.timeout)) {
      var $progress = $('<div class="progress"><div class="progress-bar progress-bar-' + type + ' progress-bar-striped" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div> </div>');
      var transition = "width " + options.timeout / 1000 + "s linear ";
      $progress.find('.progress-bar').css({
        "-webkit-transition": transition,
        "-o-transition": transition,
        "transition": transition
      });
      $element.addClass('has-timeout').append($progress);
      setTimeout(function () {
        $progress.find(".progress-bar").css("width", "0%");
      })
      setTimeout(function () {
        slideRemainingUp($element, height);
      }, options.timeout);
    }

  }
})