
const searchSelected = $('#search-event')
const searchValue = searchSelected.val();
const dropdowntype = $("option:selected", "#search-event1").text();
const dropdownarea = $("option:selected", "#search-event2").text();


$(function() {
    $('#event-grid-button').on('click', function (e) {
        $('.list-event-view').hide();
        $('#event-grid-button').hide();
        $('.grid-event-view').show();
        $('#event-list-button').show();
    });

    $('#event-list-button').on('click', function (e) {
        $('.grid-event-view').hide();
        $('#event-list-button').hide();
        $('.list-event-view').show();
        $('#event-grid-button').show();
    });

    $("#search-event").on('change', function (e) {
        let optionSelected = $(this)
        let value = optionSelected.text
        console.log(searchValue)
        console.log(optionSelected)
        if (value!==searchValue){
            $('#event-list-button').hide();
            $('#event-grid-button').hide();
        }
        else {
            $('#event-list-button').hide();
            $('#event-grid-button').show();
        }
    });

    $("#search-event1").on('change', function (e) {
        let optionSelected = $("option:selected", this).text();
        if (optionSelected!==dropdowntype){
            $('#event-list-button').hide();
            $('#event-grid-button').hide();
        }
        else {
            $('#event-list-button').hide();
            $('#event-grid-button').show();
        }
    });

    $("#search-event2").on('change', function (e) {
        let optionSelected = $("option:selected", this).text();
        if (optionSelected!==dropdownarea){
            $('#event-list-button').hide();
            $('#event-grid-button').hide();
        }
        else {
            $('#event-list-button').hide();
            $('#event-grid-button').show();
        }
    });
});


