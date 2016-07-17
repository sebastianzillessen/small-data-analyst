(function (window, $) {
  function initPreferences() {
    var $parent = $(this);
    $parent.find(".sortable").each(function () {
      var $self = $(this);
      var options = $self.data();
      options = $.extend({
        placeholder: "label-primary",
        forcePlaceholderSize: true
      }, options);

      $self.sortable(options).on("sortupdate", function () {
        console.log("Sortchange");
        if (options.updateInput) {
          $parent.find(options.updateInput).val($(this).sortable('toArray'));
        }
      });
    })
    $parent.find("a[data-sortable-add]").on('click', function () {
      var $self = $(this);
      var $element_to_add = $($self.data('sortable-add'));
      var $target = $parent.find($self.data('sortable-add-target'));
      $target.append($element_to_add);
    })

    $parent.find(".sortable").on('mousedown contextmenu', '.label', function (e) {
        var $self = $(this);
        if (e.which == 3) {
          e.preventDefault();
          var $parent = $self.parent(".sortable");
          var $otherField = $($parent.data("connectWith"));

          setTimeout(function () {
            if (!$self.hasClass('remove-on-right')) {
              $self.detach();
              $otherField.append($self);
            } else {
              $self.remove();
            }
            $otherField.sortable('refreshPositions').sortable('refresh');
            $otherField.trigger('sortupdate');
            $parent.sortable('refreshPositions').sortable('refresh');
            $parent.trigger('sortupdate');
          }, 0);

        }
      }
    );
  }

  $(function () {
    initPreferences.apply(document);
  });
  $(document).on('cocoon:after-insert', function (e, inserted) {
    initPreferences.apply(inserted);
  })

})
(window, $);
