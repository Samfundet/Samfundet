$(function () {
    let field = $('#job_tag_titles')
    let temp = field.val()
    field.change(function (){
        temp = field.val()
    })
    $(".prev-tag-button").click(function () {
        let value = this.innerHTML
        if (!temp.includes(value)) {
            if (field.val() == "" || field.val().slice(-2) == ", ") {
                field.val(temp + value)
            } else if (field.val().slice(-1) == ","){
                field.val(temp + " " + value)
            } else {
                field.val(temp + ", " + value)
            }
            temp = field.val()

        } else {
            temp = field.val()
        }
    })
})