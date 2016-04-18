$(function() {
    function toggleInputs(siblings, checked, reset) {
        var openTimeInput = siblings.eq(0);
        var closeTimeInput = siblings.eq(1);

        if (checked == "checked") {
            openTimeInput.removeAttr("disabled");
            closeTimeInput.removeAttr("disabled");
        } else {
            openTimeInput.attr("disabled", "disabled");
            closeTimeInput.attr("disabled", "disabled");
        }
    }

    $(".standard-hour input[type=checkbox]").each(function() {
        var input_siblings = $(this).parent().parent().siblings().find("input[type=text]");
        var checked = $(this).attr('checked');

        $(this).on("change", function() {
            toggleInputs(input_siblings, $(this).attr('checked'), true);
        });

        toggleInputs(input_siblings, $(this).attr('checked'), false);
    });
});

$('#area_select').bind('change', function() { window.location.pathname = $(this).val() });
