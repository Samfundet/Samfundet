$(function() {
  $.datepicker.setDefaults({dateFormat: 'dd.mm.yy', defaultDate: +0, showWeek: true, firstDay: 1});
  $('.datetimepicker').datetimepicker();
  $('.datetimepicker_lyche').datetimepicker({hourMin: 16, hourMax: 22, stepMinute: 15});
  $('.datepicker').datepicker();
});
