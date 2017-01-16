function add_class_to_document_sublists() {
  $('.documents_list li > ul').each(function() {
    $(this).parent().addClass('sublist');
  });
}
function add_click_listener_to_document_sublists() {
  $('.documents_list li.sublist > strong').click(function(event) {
    sublist = $(this).parent();
    if (sublist.hasClass('active')) {
      sublist.find('li.active').removeClass('active');
      sublist.find('ul.active').removeClass('active');
    } else  {
      sublist.children('ul').toggleClass('active');
    }
    sublist.toggleClass('active');
  });
}
function open_most_recent() {
  $('ul.documents_list_root > li:first-child').each(function() {
    $(this).addClass('active');
    // Set ul inside of first li-element as active
    $(this).children('ul').first().addClass('active');

    // Find all ul children (1 or more levels down) from the first li element, which of the last is the one we want to to set as active
    $(this).find('ul').last().addClass('active');
    // Add active to the parent li element
    $(this).find('ul').last().parent().addClass('active');
  });
}

$(function() {
    add_class_to_document_sublists();
    add_click_listener_to_document_sublists();
    $('.documents_list > ul').addClass('documents_list_root')
    open_most_recent();
});
