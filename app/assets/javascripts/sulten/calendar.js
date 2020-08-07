/*
    Handles datetime popup for lyche calendar
*/
$(function() {
    $("#calendar-header-title").on('click', function(e) {
        $("#calendar-datepicker-container").toggleClass('open');
        e.stopPropagation();
    });
    $(window).on('click', function(e){
        $("#calendar-datepicker-container").removeClass('open');
    });
    $('#calendar-datepicker-container').datepicker({
        dateFormat: 'dd-mm-yy',
        onSelect: function(dateText) {
            var path = window.location.href
            if(path.indexOf("?") > -1){
                path = path.substr(0, path.indexOf("?"))
            }
            window.location.href = path + "?date=" + dateText;
        }
    });
    $('#calendar-datepicker-container').on('click', function(e){
        e.stopPropagation();
    })
});
