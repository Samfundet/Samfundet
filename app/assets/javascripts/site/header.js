$(function() {
  $("#header-hamburger-menu").on('click', function(event) {
    $("#header-hamburger-menu").toggleClass('open');
    $("#header-popup-menu").toggleClass('open');
    event.preventDefault();
  });
});
