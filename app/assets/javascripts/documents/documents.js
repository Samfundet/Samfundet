function add_class_to_document_submenus() {
  $('.documents_list li > ul').each(function() {
    $(this).parent().addClass('sublist');
  });
}
function add_click_listener_to_document_submenus() {
  $('.documents_list li.sublist > strong').click(function(event) {
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
function open_most_recent() {
  $('ul.document_root > li:first-child').each(function() {
    // Set list inside of first list-element as active
    $(this).children('ul').first().addClass('active');

    // Find all ul children (1 or more levels down) from the first li element, which of the last is the one we want to to set as active
    $(this).find('ul').last().addClass('active');
  });
}

$(function() {
    add_class_to_document_submenus();
    add_click_listener_to_document_submenus();
    $('.documents_list > ul').addClass('document_root')
    open_most_recent();
});
