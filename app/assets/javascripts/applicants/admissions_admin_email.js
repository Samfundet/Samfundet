$(function() {
    $('input').keyup(function (event) {
        var intro = $('input[name="introduction"]').val()
        var subj = $('input[name="subject"]').val()
        $("#preview-subject").text(subj)
        $("#preview-intro").text(intro+" <fornavn>,")
    });
    $('textarea').keyup(function (event) {
        var content = $('textarea[name="content"]').val()
        $("#preview-content").text(content)
    });
});