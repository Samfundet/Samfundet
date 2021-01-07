// Since list is loaded async, we must add this code after load finishes
$(document).on('render_async_load', function(event) {

    $(function () {
        $("#hide_withdrawn").click(function (event) {
            $(".job_application_table").toggleClass('hide-withdrawn');
        });
    });

    $(function () {
        $("#colorblind_mode").click(function (event) {
            $(".job_application_table").toggleClass('colorblind');
            $(".color_description").toggleClass('display-none')
        });
    });

    $(function () {
        $("#show_color_explanations").click(function (event) {
            $("#color_explanations").toggleClass('display-none');
        });
    });

});