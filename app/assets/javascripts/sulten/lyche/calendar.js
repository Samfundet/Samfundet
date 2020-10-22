/* Datepicker for lyche reservation form */

$(function() {
    $('#lyche-datepicker').datepicker( {
        monthNames: [ "Januar", "Februar", "Marts", "April", "Maj", "Juni", "Juli", "August", "September", "Oktober", "November", "December" ],
        maxDate: new Date(2020, 1 - 1, 1),
        dateFormat: 'dd-mm-yy',
        onSelect: function(dateText) {
            var path = window.location.href
            if(path.indexOf("?") > -1){
                path = path.substr(0, path.indexOf("?"))
            }
            window.location.href = path + "?date=" + dateText;
        }
    });
});