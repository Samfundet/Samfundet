
$('#gridbutton').on('click',function(e) {
    if($(this).hasClass('list')) {
        $('#container ul').removeClass('grid').addClass('list');
    }
    else if ($(this).hasClass('grid')) {
        $('#container ul').removeClass('list').addClass('grid');
    }
});