$(function () {
  $('[data-before-submit]').bind('ajax:before', function (e) {
    var href = $(this).data('original-href');
    if (!href) {
      href = $(this).attr('href');
      $(this).data('original-href', href);
    }
    if (href.indexOf('?') == -1) {
      href += '?';
    }
    else {
      href += '&';
    }
    var options = $(this).data('before-submit');
    $.each(options, function (key, id) {
      href += key + "=" + encodeURI($(id).val()) + "&";
    });
    $(this).attr('href', href);
    e.preventDefault();
  });
});