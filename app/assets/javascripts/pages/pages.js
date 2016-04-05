$(function() {
  $('.menu-button').on('click', function(e) {
    $('.menu-content').toggleClass("show-menu-content");
  });

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
  $('.menu-content h1').click(function() {
    $(this).toggleClass('active');
    $(this).next('ul').toggleClass('active');
  });
  $('.menu-content li > ul').parent().addClass('submenu');

  $('.menu-content li.submenu').click(function() {
    $(this).toggleClass('active');
    $(this).children('ul').toggleClass('active');
  });
});
