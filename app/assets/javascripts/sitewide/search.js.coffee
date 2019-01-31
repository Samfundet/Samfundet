window.bind_search = (search_form, search_input, existing_results, ajax_results, search_constraints) ->
  timer = null

  showSearch = ->
    $(existing_results).slideUp()
    $(ajax_results).slideDown();

  hideSearch = ->
    $(existing_results).slideDown()
    $(ajax_results).slideUp()
    $(search_form).val ""

  getQuery = ->
    user_query = $(search_input).val()
    query_constraints = $.map $(search_constraints), (constraint)->
      $(constraint).val()
    $.trim (query_constraints.join(" ") + " " + user_query)

  updateSearch = (event) ->
    unless event == undefined
      event.preventDefault()

    query = getQuery()
    unless query
      hideSearch()
      return

    form = $(search_form)
    serialized_form = form.serialize()
    form_endpoint = form.attr('action')

    $.ajax({
    type: 'POST',
    url: form_endpoint,
    data: {
        search: query
    },

    }).then (data, textStatus, xhr) ->
        $(ajax_results).html data
        showSearch()
        ga('send', 'pageview',
          'page': form_endpoint + "?" + serialized_form,
          'title': 'Search - Virtual'
        );

  scrollToSearch = ->
    width = $(window).width()
    if width <= 480
      $("html, body").animate
        scrollTop: $(search_form).offset().top - 10

  $(document).on
    "submit" : updateSearch
    "search" : updateSearch
    , search_form

  $(document).on
    "change" : (event) ->
        updateSearch event
    , search_form + " " + search_constraints

  $(document).on
    "focus" : scrollToSearch
    "keyup" : (event) ->
      unless getQuery()
        hideSearch()
        return

      clearTimeout timer
      timer = setTimeout updateSearch, 600;
    , search_input
