$(function() {
    $("#header-menu-button-mobile").on('click', function(event) {
        $("#header-menu-button-mobile").toggleClass('open');
        $("#header-menu-mobile").toggleClass('open');
        event.preventDefault();
    });
    $("#header-menu-mobile").on('click', function(event) {
        $("#header-menu-button-mobile").removeClass('open');
        $("#header-menu-mobile").removeClass('open');
    });
    $(".header-menu-item").on('click', function(event) {
        event.stopPropagation();
    });
});