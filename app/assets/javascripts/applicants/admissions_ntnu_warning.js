$(function() {
    $("#applicant_email").on("input", function (event) {
        if($("#applicant_email")[0].value.toString().includes("@ntnu.no")) {
            $(".ntnu_warning").css("display", "block");
        } else {
            $(".ntnu_warning").css("display", "none");
        }
    });
});