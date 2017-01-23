
(function () {
   $('form.feedback-form').submit(function (event) {
    var form = $(this);
    $.ajax({
      type: "POST",
      url: form.attr('action'),
      data: form.serialize(),
      success: function (data) {
        //form.hide();
        alert(data.token);
      },
      dataType: 'json'
    });

    return false;
   }).find("input[type='submit']").hide();
   
   $('form.feedback-form label').click(function () {
    $('form.feedback-form').submit();
   });

})();
