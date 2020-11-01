$(function() {
  $("#hide_withdrawn").click(function (event) {
      $(".job_application_table").toggleClass('hide-withdrawn');
  });
});

$(function() {
    $("#hide_rejected").click(function (event) {
        $(".job_application_table").toggleClass('hide-rejected');
    });
});

$(function() {
  $("#colorblind_mode").click(function (event) {
    $(".job_application_table").toggleClass('colorblind');
    $(".color_description").toggleClass('display-none')
  });
});

