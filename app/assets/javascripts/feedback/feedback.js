
(function () {
   $('form.feedback-form').submit(function (event) {
    var form = $(this);
    console.log(form.serialize());
    $.ajax({
      type: "POST",
      url: form.attr('action'),
      data: form.serialize(),
      success: function (data) {
        alert(data.alternative);
        alert(data.token);
      },
      dataType: 'json'
    });

    return false;
   }).find("input[type='submit']").hide();
   
   $('form.feedback-form label').click(function () {
     $(this).parent().find('input').attr('checked', 'checked');
     $(this).parent().submit();
   });

})();
