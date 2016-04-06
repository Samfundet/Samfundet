function set_active_menu_item() {
  function page_name(url) {
    var parts = url.split('#')[0].split('/');
    return parts[parts.length - 1];
  }
  $('.menu-content a').each(function() {
    if(page_name(window.location.pathname) == page_name($(this).attr('href'))) {
        $(this).addClass('current');
        $(this).parents('ul, li').addClass('active');
        $(this).parents('ul').prev('h1').addClass('active');
    }
  });
}

function add_class_to_submenus() {
  $('.menu-content li > ul').each(function() {
    $(this).parent().addClass('submenu');
  });
}
function add_click_listener_to_submenus() {
  $('.menu-content li.submenu').click(function(event) {
    event.stopPropagation();
    if ($(this).hasClass('active')) {
      $(this).find('li.active').removeClass('active');
      $(this).find('ul.active').removeClass('active');
    } else  {
      $(this).children('ul').toggleClass('active');
    }
    $(this).toggleClass('active');
  });
}

$(function() {

    // Menu toggle for mobile
    $('.menu-button').on('click', function(e) {
        $('.menu-content').toggleClass("show-menu-content");
    });

    set_active_menu_item();
    add_class_to_submenus();
    add_click_listener_to_submenus();
    $('.menu-content > ul').addClass('menu_root')
});
