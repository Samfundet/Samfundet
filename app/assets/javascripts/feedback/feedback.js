
(function () {

  var forms = $('form.feedback-form'),
      index = 0;

  forms.submit(function (event) {
  var form = $(this);
  $.ajax({
    type: "POST",
    url: form.attr('action'),
    data: form.serialize(),
    error: function (j, message, e) {
      alert(message+e);
    },
    success: function (data) {
      if (data.message == "Success") {
        index++;
        hideForms();
      }
    },
    dataType: 'json'
  });

  return false;
  });

  function hideForms() {
    forms.hide();
    $(forms.get(index)).show();
    if (index => forms.length) {
      surveyDone();
    }
  }
  hideForms();

  function surveyDone() {
    $('.feedback-end-message').show();
  }
  $('form.feedback-form label').click(function () {
    var form = $(this).parent();
    form.find('input').attr('checked', 'checked');
    form.find("label").removeClass("feedback-sucess");
    form.find("input:checked").parent().addClass("feedback-sucess");

  });

  $('form.feedback-form ')

})();
