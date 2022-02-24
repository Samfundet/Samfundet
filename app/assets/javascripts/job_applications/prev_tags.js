$(function () {
    let field = $('#job_tag_titles')
    let temp = field.val()
    field.change(function (){
        temp = field.val()
    })
    $(".prev-tag-button").click(function () {
        let value = this.innerHTML
        if (!temp.includes(value) && field.val() != "") {
            field.val(temp + ", " +value)
            temp = field.val()
        } else if (!temp.includes(value) ){
            field.val(temp + value)
            temp = field.val()
        }
    })
    temp = field.val()
})