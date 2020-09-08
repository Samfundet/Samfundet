/* Datepicker for lyche reservation form */

$(function() {
   $('#lyche-datepicker').datepicker({
       dateFormat: 'dd-mm-yy',
       onSelect: function(dateText) {
           var path = window.location.href
           if (path.indexOf("?") > -1){
               path = path.substr(0, path.indexOf("?"))
           }
           window.location.href = path + "?date=" + dateText;

       }
   })
});