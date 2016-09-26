$(document).on('click', '.modal a.image', function (e) {
  e.preventDefault();

  var selected_image_id = $(this).data('image');
  var selected_image_url = $(this).data('url')

  $(".image_id_input").val(selected_image_id);
  $('.image-preview').attr('src', selected_image_url);

  $.modal.close();
});

$(document).on('click', '.modal .pagination a', function(e) {
  e.preventDefault();

  $(".modal").load(this.href).open();
});

$('.choose-image-link').on('click', function(e) {
  e.preventDefault();
  $(this).modal();

  $("html, body").animate({ scrollTop: 0 }, "slow");
});
