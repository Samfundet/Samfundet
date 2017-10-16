var surveyProperties = {
    autoSubmit: true,
    hidePaginationInitially: true,
};

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
      setTimeout(function() {
          callback($(html).appendTo('body').modal({
              clickClose: false,
              escapeClose: false,
          }).on($.modal.CLOSE, closeModal));
      }, 1000);
    });
}

function setUp(modal) {
    var index = 0;
    var stack = [$('.feedback-start-message')].concat($('form.feedback-form').toArray(),
          [$('.feedback-end-message')]);

    function showMessage(m) {
      $('.feedback-wrapper .message-box').text(m).show().delay(1500).slideUp();
    }

    function ajaxSubmit (form) {
      var form = $(form);

      if (form.find('input[type="radio"]:checked').length == 0) {
        return;
      }

      $.ajax({
        type: "POST",
        url: form.attr('action'),
        beforeSend: function(xhr) {
          xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
        },
        data: form.serialize(),
        error: function (j, m, e) {
          showMessage('Noe gikk galt: ' + m);
          console.log(e);
        },
        success: function (data) {
          if (data.success) {
            next();
          } else {
            showMessage('Noe gikk galt: ' + (data.message ? data.message : data));
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

      if (index == 0) {
        $('.feedback-wrapper .pagination').hide();
      }
      else {
        $('.feedback-wrapper .pagination').show();

        if (index < stack.length-1) {
          $('.feedback-wrapper .feedback-next').show();
        } else {
          $('.feedback-wrapper .feedback-next').hide();
        }

        if (index > 1) {
          $('.feedback-wrapper .feedback-previous').show();
        } else {
          $('.feedback-wrapper .feedback-previous').hide();
        }
      }
    }

    function next(e) {
      index++;
      updateStack();
    }

    function submitAndNext() {
      if (index < stack.length-1) {
        if (index > 0) {
          ajaxSubmit(stack[index]);
          if (index == stack.length-1) {
            $('.feedback-wrapper .pagination').hide();
          }
        } else {
          next();
        }
      }
    }

    function previous(e) {
      if (index > 1) {
        index--;
        updateStack();
      }
    }

    function quitSurvey(e) {
      modal.find('.close-modal').click();
    }

    if (surveyProperties.hidePaginationInitially) {
      $('.feedback-wrapper .pagination').hide();
    }

    updateStack();

    $('.feedback-wrapper .feedback-previous').click(previous);

    $('.feedback-wrapper #feedback-start-survey').click(next);

    $('.feedback-wrapper #feedback-skip-survey').click(quitSurvey);

    if (surveyProperties.autoSubmit) {
      $('.feedback-wrapper form input[type="radio"]').on('change', submitAndNext);
    }

    $('.feedback-wrapper .feedback-next').click(submitAndNext);

    $('.feedback-wrapper #feedback-end-survey').click(quitSurvey);
}

if ($('.modalDiv').length > 0){
    var surveyPath = $('.modalDiv').get(0).id;
    setUp($('.feedback-wrapper'));
    openInModal(surveyPath, setUp);
}
