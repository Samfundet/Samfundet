
window.onscroll = function (e) {
    var scrollTop = $(window).scrollTop()

    if (scrollTop > 100) {
        $("#lyche-header-container").addClass("compact")
    }else {
        $("#lyche-header-container").removeClass("compact")
    }
}

$(function() {
    $(".mobile-hamburger").on('click', function(event) {
        $(".mobile-hamburger").toggleClass('open');
        $(".mobile-hamburger-menu").toggleClass('open');
        event.preventDefault();
    });
});