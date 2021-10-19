$(function() {
    $('#event-grid-button').on('click', function (e) {
        $('#list-event-view').hide()
        $('#grid-event-view').show()
    });

    $('#event-list-button').on('click', function (e) {
        $('#grid-event-view').hide()
        $('#list-event-view').show()
    });
});
