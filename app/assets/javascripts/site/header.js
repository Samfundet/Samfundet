$(function() {

  $("#info-button").on('click', function(event) {
    $("#info-button").toggleClass('enabled');
    $("#info-drawer").toggleClass('hidden');
    $(".info-drawer-hide-other").toggleClass('hidden');
    event.preventDefault();
  });

  $("#header-hamburger-menu").on('click', function(event) {
    $("#header-hamburger-menu").toggleClass('open');
    $("#header-popup-menu").toggleClass('open');
    $("#info-button").removeClass('enabled');
    $("#info-drawer").addClass('hidden');
    $(".info-drawer-hide-other").removeClass('hidden');
    $("#venues-button").removeClass('enabled');
    $("#venues-drawer").addClass('hidden');
    $(".venues-drawer-hide-other").removeClass('hidden');
    event.preventDefault();
  });

  $("#venues-button").on('click', function(event) {
    $("#venues-button").toggleClass('enabled');
    $("#venues-drawer").toggleClass('hidden');
    $(".venues-drawer-hide-other").toggleClass('hidden');
    event.preventDefault();
  });


});
