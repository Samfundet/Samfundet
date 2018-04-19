var surveyProperties = {
  autoSubmit: true,
  hidePaginationInitially: true,
};

var popped = false;

function openInModal(url, callback) {
  history.pushState(null, "", '#survey');
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
  // check index of
  var index = 0;
  var stack = $('form.feedback-form').toArray().concat( [$('.feedback-end-message')]);

  function showMessage(m) {
    $('.feedback-wrapper .message-box').text(m).show().delay(500).slideUp();
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
        showMessage('Something went wrong: ' + m);
        console.log(e);
      },
      success: function (data) {
        if (data.success) {
          next();
        } else {
          showMessage('Something went wrong: ' + (data.message ? data.message : data));
        }
      }
    });
  }

  function updateStack() {
    $('#current-index').text(index.toString());
    // shows each question corresponding to the correct index
    $.each(stack, function (i, e) {
      if (i != index) {
        $(e).hide();
      } else {
        $(e).show();
      }
    });

    // only display current question counter if there's a question active
    if (index == 0 || index == stack.length-1) {
      $('.feedback-wrapper .pagination').hide();
    }
    else {
      $('.feedback-wrapper .pagination').show();
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
      }
      else {
        next();
      }
    }
    else {
      $('#current-index').text(index.toString());
    }
  }

  function quitSurvey(e) {
    modal.find('.close-modal').click();
  }

  if (surveyProperties.hidePaginationInitially) {
    $('.feedback-wrapper .pagination').hide();
  }

  updateStack();

  $('.feedback-wrapper #feedback-start-survey').click(next);

  $('.feedback-wrapper #feedback-skip-survey').click(quitSurvey);

  $('.feedback-wrapper #feedback-end-survey').click(quitSurvey);

  if (surveyProperties.autoSubmit) {
    $('.feedback-wrapper form input[type="radio"]').on(
      'change', function() {
        setTimeout(submitAndNext, 269);
      }
    );
  }
}

// Åpner survey når man klikker på 'start survey'
document.getElementById('openFeedbackSurvey').addEventListener('click',function(e)
{
  if ($('.modalDiv').length > 0){
    var surveyPath = $('.modalDiv').get(0).id;
    setUp($('.feedback-wrapper'));
    openInModal(surveyPath, setUp);
    console.log('Hei');
  } 
});
