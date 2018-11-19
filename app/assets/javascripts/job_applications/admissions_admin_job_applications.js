$(function() {
  $("#hide_withdrawn").click(function (event) {
    $(".withdrawn").toggleClass('display-none');
  });
});

$(function() {
  $("#colorblind_mode").click(function (event) {
    $(".job_application_table").toggleClass('colorblind');
    $(".color_description").toggleClass('display-none')
  });
});
