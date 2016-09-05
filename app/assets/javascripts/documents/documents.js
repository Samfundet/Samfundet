function add_class_to_document_submenus() {
  $('.documents_list li > ul').each(function() {
    $(this).parent().addClass('submenu');
  });
}
function add_click_listener_to_document_submenus() {
  $('.documents_list li.submenu > strong').click(function(event) {
    event.stopPropagation();
    submenu = $(this).parent();
    if (submenu.hasClass('active')) {
      submenu.find('li.active').removeClass('active');
      submenu.find('ul.active').removeClass('active');
    } else  {
      submenu.children('ul').toggleClass('active');
    }
    submenu.toggleClass('active');
  });
}

$(function() {

    set_active_menu_item();
    add_class_to_document_submenus();
    add_click_listener_to_document_submenus();
    $('.documents_list > ul').addClass('menu_root')
});
