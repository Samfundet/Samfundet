$(function() {
    $("#header-menu-button-mobile").on('click', function(event) {
        $("#header-menu-button-mobile").toggleClass('open');
        $("#header-menu-mobile").toggleClass('open');
        event.preventDefault();
    });
});