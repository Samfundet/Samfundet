
(function () {

  var index = 0,
      stack = [$('.feedback-start-message')].concat($('form.feedback-form').toArray(), [$('.feedback-end-message')]);

  function ajaxSubmit (form) {
    var form = $(form);
    $.ajax({
      type: "POST",
      url: form.attr('action'),
      data: form.serialize(),
      error: function (j, m, e) {
        alert('Noe gikk galt: ' + e);
      },
      success: function (data) {
        if (data.success) {
          index++;
          updateStack();
        }
      },
      dataType: 'json'
    });

  }

  function updateStack() {
    $.each(stack, function (i, e) {
      if (i != index) {
        $(e).hide();
        $('#feedback-index-'+i).removeClass("active");
      } else {
        $(e).show();
        $('#feedback-index-'+i).addClass("active");
      }
    });
  }

  updateStack();

  $('.feedback-wrapper .feedback-previous').click(function (e) {
    if (index > 0) {
      index--;
      updateStack();
    }
  });

  $('.feedback-wrapper .feedback-next').click(function (e) {
    if (index < stack.length-1) {
      if (index > 0) {
        ajaxSubmit(stack[index]);
      } else {
        index++;
        updateStack();
      }
    }
  });

})();
