$(function() {
    $('#event-grid-button').on('click', function (e) {
        $('#list-event-view').hide();
        $('#event-grid-button').hide();
        $('#grid-event-view').show();
        $('#event-list-button').show();
    });

    $('#event-list-button').on('click', function (e) {
        $('#grid-event-view').hide();
        $('#event-list-button').hide();
        $('#list-event-view').show();
        $('#event-grid-button').show();
    });
});
