$(function() {
  $('.menu-button').on('click', function(e) {
    $('.menu-content').toggleClass("show-menu-content");
  });

  function page_name(url) {
    var parts = url.split('#')[0].split('/');
    return parts[parts.length - 1];
  }
  $('.menu-content li > ul').each(function() {
    $(this).parent().addClass('submenu');
  });
  $('.menu-content a').each(function() {
    if(page_name(window.location.pathname) == page_name($(this).attr('href'))) {
        $(this).addClass('current');
        $(this).parents('ul, li').addClass('active');
        $(this).parents('ul').prev('h1').addClass('active');
    }
  });
  $('.menu-content h1').click(function() {
    if ($(this).hasClass('active')) {
      $(this).next('ul').find('ul.active').toggleClass('active');
      $(this).next('ul').find('li.active').toggleClass('active');
    }
    $(this).next('ul').toggleClass('active');
    $(this).toggleClass('active');
  });

  $('.menu-content li.submenu').click(function(event) {
    event.stopPropagation();
    if ($(this).hasClass('active')) {
      $(this).find('ul.active').toggleClass('active');
      $(this).find('li.active').toggleClass('active');
    } else  {
      $(this).children('ul').toggleClass('active');
    }
    $(this).toggleClass('active');
  });
});
