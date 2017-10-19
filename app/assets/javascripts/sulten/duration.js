//If occation is food, set minimum value to 90 minutes

//Formtastic initialises sulten_reservation_reservation_duration selectoren with :collector
$("#sulten_reservation_reservation_type_id").change(function(){
var preValue = parseInt($("#sulten_reservation_reservation_duration").find(":selected").val())
var durationOptions = null;
const drinkOptions = [30, 60, 90, 120]
const foodOptions = [90, 120, 150, 180]

  //In prod the values are:
  //mat = 2
  //drikke = 3

  //In testing the values are:
  //drikke = 5
  //mat/drikke = 6

  //if testing, change 'this.val()==' to reflect the "Mat/drikke" value in development.
  //remember to change it back to 2 afterwards
  if($(this).val() == 2){
    durationOptions = foodOptions;
  }
  else {
    durationOptions = drinkOptions;
  }

  $("#sulten_reservation_reservation_duration option").remove()
  $.each(durationOptions,function(i,v){
    $("#sulten_reservation_reservation_duration").append($("<option />").val(v).text(v + " minutter"))
  })
  console.log(durationOptions)
  console.log(jQuery.inArray(preValue,durationOptions))
  if (jQuery.inArray(preValue,durationOptions) > -1){
    $("#sulten_reservation_reservation_duration").val(preValue)
  }
});
