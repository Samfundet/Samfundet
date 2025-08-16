$(function () {
    $("#applicant_email").on("input", function (event) {
        const email = $("#applicant_email")[0].value.toString().toLowerCase();
        if (email.includes("@ntnu.no")) {
            $(".ntnu_warning").css("display", "block");
        } else if (email.includes("@microsoft.") || email.includes("@live.") || email.includes("@outlook.") || email.includes("@hotmail.")) {
            $(".microsoft_warning").css("display", "block");
        } else {
            $(".ntnu_warning").css("display", "none");
            $(".microsoft_warning").css("display", "none");
        }
    });
});