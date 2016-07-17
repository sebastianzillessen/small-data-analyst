$(function () {
  $(".resize-on-click").on('click', function (e) {
    e.stopPropagation();
    var $o = $("body #img-overlay");
    if ($o.length == 0) {
      $o = $("<div id='img-overlay'>" +
        "<div class='center'>" +
        "<a class='close'>&#10006;</a>" +
        "<div class='content'><img/>" +
        "</div>" +
        "</div>" +
        "</div>");
      $("body").prepend($o);
    }
    if ($o.is(":visible")) {
      $o.fadeOut();
    }
    else {
      $o.find('.content img').attr('src', $(this).find("img").attr('src'));
      $o.fadeIn();
    }
  })
  $("body").on('click', function () {
    $("body #img-overlay:visible").fadeOut();
  })
  $(window).on('scroll', function () {
    $("body #img-overlay:visible").fadeOut();
  });
})