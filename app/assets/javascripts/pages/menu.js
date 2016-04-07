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
  $('.menu-content li.submenu > strong').click(function(event) {
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

    // Menu toggle for mobile
    $('.menu-button').on('click', function(e) {
        $('.menu-content').toggleClass("show-menu-content");
    });

    set_active_menu_item();
    add_class_to_submenus();
    add_click_listener_to_submenus();
    $('.menu-content > ul').addClass('menu_root')
});
