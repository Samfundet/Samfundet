$(function() {
    $('#event-grid-button').on('click', function (e) {
        console.log("hi")
        $('#list-event-view').hide()
        $('#grid-event-view').show()
    });

    $('#event-list-button').on('click', function (e) {
        console.log("hi")
        $('#grid-event-view').hide()
        $('#list-event-view').show()
    });
});
