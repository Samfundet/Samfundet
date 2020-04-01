
window.onscroll = function (e) {
    var scrollTop = $(window).scrollTop()

    if (scrollTop > 100) {
        $("#lyche-header-container").addClass("compact")
    }else {
        $("#lyche-header-container").removeClass("compact")
    }
}
