$(function() {
    $('input').keyup(function (event) {
        var intro = $('input[name="introduction"]').val()
        var subj = $('input[name="subject"]').val()
        $("#preview-subject").html(subj)
        $("#preview-intro").html(intro+" Pernille,")
    });
    $('textarea').keyup(function (event) {
        var content = $('textarea[name="content"]').val()
        $("#preview-content").html(content)
    });
});