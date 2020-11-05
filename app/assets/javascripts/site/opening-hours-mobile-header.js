$(function() {
    $("#opening-hours-button").on('click', function() {
        $(".opening-hours").slideToggle(500)
        $("#opening-hours-button").toggleClass("open")
    });
});