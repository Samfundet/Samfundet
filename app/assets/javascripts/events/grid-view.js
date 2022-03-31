$(function() {
    const search = $('#search-event').value();
    let dropdowntype = $("option:selected", "#search-event1").text();
    let dropdownarea = $("option:selected", "#search-event2").text();

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

    $("#search-event").on('input', function (e) {
        let optionSelected = $(this)
        console.log(optionSelected)
        console.log(search)
        console.log("heisann deisann woopsan")
        if (optionSelected!==search){
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
            $('.grid-event-view').show();
            $('.list-event-view').hide();
            $('#event-list-button').show();
            $('#event-grid-button').hide();
        }
    });

    $("#search-event2").on('change', function (e) {
        let optionSelected = $("option:selected", this).text();
        if (optionSelected!==dropdownarea){
            $('#event-list-button').hide();
            $('#event-grid-button').hide();
        }
        else {
            $('.grid-event-view').show();
            $('.list-event-view').hide();
            $('#event-list-button').show();
            $('#event-grid-button').hide();
        }
    });
});


