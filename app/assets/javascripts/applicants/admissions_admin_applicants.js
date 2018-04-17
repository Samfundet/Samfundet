$(function() {
    $("#show_reserved").click(function (event) {
        $(".reserved").toggleClass('display-reserved');
    });
});

$(function() {
    $("#show_not_set").click(function (event) {
        $(".not_set").toggleClass('display-not-set');
    });
});
