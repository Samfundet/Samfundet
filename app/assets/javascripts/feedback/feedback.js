
(function () {
   $('form.feedback-form').submit(function (event) {
    var form = $(this);
    $.ajax({
      type: "POST",
      url: form.attr('action'),
      data: form.serialize(),
      success: function (data) {
        form.hide();
        alert(data);
      },
      dataType: 'json'
    });

    return false;
   });
})();
