
$(function () {

  var popped = false;

  function openInModal(url, callback) {
    history.pushState(null, null, '#survey');
    popped = true;
    openModal(url, callback);
  }

  function closeModal() {
        $(this).remove();
        history.pushState(null, null, '#');
        popped = true;
        $('html, body').animate({
          scrollTop: 0
        }, 1000);
  }

  function openModal(url, callback) {
    $.get(url, function(html) {
    $("html, body").animate({ scrollTop: 0 }, "slow");
      callback($(html).appendTo('body').modal({
        clickClose: false,
        escapeClose: false,
      }).on($.modal.CLOSE, closeModal));
    });
  }

  function setUp(modal) {
    var index = 0;
    var stack = [$('.feedback-start-message')].concat($('form.feedback-form').toArray(),
          [$('.feedback-end-message')]);

    function ajaxSubmit (form) {
      var form = $(form);
      $.ajax({
        type: "POST",
        url: form.attr('action'),
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        data: form.serialize(),
        error: function (j, m, e) {
          alert('Noe gikk galt: ' + e);
        },
        success: function (data) {
          if (data.success) {
            index++;
            updateStack();
          } else {
            alert('Noe gikk galt: ' + (data.message ? data.message : data));
          }
        }
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

      if (index == 0 || index == stack.length-1) {
        $('.feedback-wrapper .pagination').hide();
      } else {
        $('.feedback-wrapper .pagination').show();
      }
    }

    $('.feedback-wrapper .pagination').hide();
    updateStack();

    $('.feedback-wrapper .feedback-previous').click(function (e) {
      if (index > 1) {
        index--;
        updateStack();
      }
    });

    $('.feedback-wrapper #feedback-start-survey').click(function (e) {
      index++;
      updateStack();
    });

    $('.feedback-wrapper #feedback-skip-survey').click(function (e) {
      modal.find('.close-modal').click();
    });

    $('.feedback-wrapper .feedback-next').click(function (e) {
      if (index < stack.length-1) {
        if (index > 0) {
          ajaxSubmit(stack[index]);
          if (index == stack.length-1) {
            $('.feedback-wrapper .pagination').hide();
          }
        } else {
          index++;
          updateStack();
        }
      }
    });
  }

  if (surveyPath) {
    openInModal(surveyPath, setUp);
  }

});
