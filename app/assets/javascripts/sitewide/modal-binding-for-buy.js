// How to make modal work in dev:
//
// You must put the ga-function (google analytics) in a comment.
// It is important to not include this change before pushing  when adding changes with
// git add -p
// when you see this change, enter 'n' to not include it.

$(function() {
  function fragmentToBuyLink(fragment) {
    var routes = {
      'en': '/en/events/',
      'no': '/arrangement/'
    };

    return routes[$('html').attr('lang')] + fragment;
  }

  function findParentEvent(element) {
    $(element).parents().each(function() {
      if($(this).hasClass('upcoming-event')) {
        element = this;
      }
    });
    return element;
  }

  // Chrome fires the onpopstate even on regular page loads,
  // so we need to detect that and ignore it.
  var popped = ('state' in window.history && window.history.state !== null), initialURL = location.href;

  // Keep track of ticket groups and their ticket limits
  var ticketGroups = getTicketGroups();
  var ticketLimits = getTicketLimits(ticketGroups);

  // Get the default price group ticket limit
  var defaultPriceGroupTicketLimit = getDefaultTicketLimit();

  function openPurchaseModal(url, source) {

    //-- -Hide ga-function in comment to make modal work in dev ---//

    ga('send', 'pageview', {
      'page': url,
      'title': 'Purchase event - Virtual'
    });

    //---End comment here ---//

    $.get(url, function(html) {
    $("html, body").animate({ scrollTop: 0 }, "slow");
      $(html).appendTo('body').modal({
        clickClose: false,
        escapeClose: false,
      }).on($.modal.CLOSE, function(e) {
        $(this).remove();
        ga('send', 'pageview');
        history.pushState(null, null, '#');
        popped = true;
        $('html, body').animate({
          scrollTop: $(findParentEvent(source)).offset().top
        }, 1000);
      });
    });
  }

  function openPurchaseModalBasedOnHash() {
      var fragment = window.location.hash.substr(1);
      if(fragment.match(/buy$/)) {
        openPurchaseModal(fragmentToBuyLink(fragment), $('body').eq(0));
      }
      else {
        if ($.modal.close()) { ga('send', 'pageview'); }
      }
  }
  openPurchaseModalBasedOnHash();

  $(document).on('click', 'a.purchase-button', function(e) {
    history.pushState(null, null, '#' + this.getAttribute('data-event-id') + '/buy');
    popped = true;
    openPurchaseModal(this.pathname, this);
    e.preventDefault();
  });

  $(window).bind('popstate', function (e) {
    var initialPop = !popped && location.href == initialURL;
    popped = true;

    if(initialPop) return;

    openPurchaseModalBasedOnHash();
  });

  $(document).on('keyup blur', '#cardnumber, #email, #email_confirmation',
      function clearOtherInputOnType() {

    // Only clear other form if we've written something
    if ($(this).val() == '') {
      return;
    }

    var id = '#' + $(this).attr('id');
    $(id)
      .siblings('input:radio')
      .prop('checked', true);

    if (id === '#cardnumber') {
      $('#email, #email_confirmation').val('');
    } else {
      $('#cardnumber').val('');
    }
  });

  $(document).on('focus', '.billig-buy input[type=radio]',
      function enforceRadioChoice() {

    // Clear selected and other input fields
    var textfield = $(this).siblings('input[type=text], input[type=email]');

    var id = '#' + textfield.attr('id');
    if (id === '#cardnumber') {
      $('#email, #email_confirmation').val('');
    } else {
      $('#cardnumber').val('');
    }
  });

  function getDefaultTicketLimit() {
    return parseInt($('.ticket-table').data('default'));
  }

  function getTicketGroups(){
    var ticketGroupOverview = {};

    $('.ticket-group-row').each(function() {
      ticketGroup = $(this).attr('id');
      ticketGroupOverview[ticketGroup] = $('.price-group-row select').find('.'+ticketGroup).map(function(){
      return $(this);
      }).get();
    });

    return Object.keys(ticketGroupOverview);
  }

  function getTicketLimits(ticketGroups){
    var ticketLimits = [];

    $.each(ticketGroups, function(i, group) {
      var classPattern = /ticket-limit-\d+/;
      var textPattern = /\D/g;
      var ticketGroupClass = $('#'+group).attr('class').match(classPattern)[0];
      var ticketGroupLimit = ticketGroupClass.replace(textPattern, '');
      ticketLimits.push(parseInt(ticketGroupLimit));
    });

    return ticketLimits;
  };

  function showLimitReachedAnimation(ticketGroupId) {
    var ticketLimitHeader = $('#' + ticketGroupId).find('.ticket-limit-hd');
    var repeats = 2;
    for (var i = 0; i < repeats; i++) {
      ticketLimitHeader.animate( { fontSize: '+=.15em' }, 'normal');
      ticketLimitHeader.animate( { fontSize: '-=.15em' }, 'normal');
    }
  }

  $('.ticket-table select').change(function() {
    // Keep track of sums related to ALL ticket groups
    var totalTickets = 0;
    var totalCost = 0;

    // Variables that relate to the ticket group that fired the change event
    var ticketGroupId = $(this).attr('class');
    var ticketGroupIndex = parseInt(ticketGroupId.match(/\d+/g)[0]);
    var ticketGroupTickets = 0;
    var ticketGroupLimit = ticketLimits[ticketGroupIndex];
    var ticketGroupHeader = $('#' + ticketGroupId).find('.ticket-limit-hd');
    var numberOfPriceGroups = 0;

    // Get the number of tickets chosen in current ticket group
    $('select.'+ticketGroupId).each(function() {
      ticketGroupTickets += parseInt($(this).val());
      numberOfPriceGroups += 1;
    });

    // Show limit reached animation if ticket group has a ticket limit and
    // the ticket limit has been reached
    if (ticketGroupTickets > 0 && ticketGroupTickets === ticketGroupLimit) {
      showLimitReachedAnimation(ticketGroupId);
    }

    // Match translation in ticket limit header
    // 'billett(er)' or 'ticket(s)'
    var ticketTranslation = ticketGroupHeader.text().match(/[aA-zZ]+.[aA-zZ]+./g);
    ticketGroupHeader.text(ticketGroupTickets + '/' + ticketGroupLimit + ' ' + ticketTranslation);

    // Empty dropdowns and populate them with legal options
    $('select.' + ticketGroupId).each(function(){

      var chosenValue = parseInt($(this).val());
      var legalOptions = chosenValue + (ticketGroupLimit-ticketGroupTickets);
      var optionsLimit = ticketGroupLimit;
      var defaultTicketGroupLimit = defaultPriceGroupTicketLimit * numberOfPriceGroups;

      // If the default price group ticket limit is used, then the limit
      // for each price group is the default price group ticket limit
      // and not the ticket group ticket limit
      if (ticketGroupLimit === defaultTicketGroupLimit){
        optionsLimit = Math.floor(ticketGroupLimit/numberOfPriceGroups);
      }

      $(this).empty();

      for (var i = 0; i <= optionsLimit; i++) {
        if (i <= legalOptions) {
          $(this).append($("<option></option>").attr("value",i).text(i));
        } else {
          $(this).append($("<option disabled></option>").attr("value",i).text(i));
        }
      }

      $(this).val(chosenValue);

      // Disable/enable dropdown based on number of legal options
      // $(this).prop("disabled", !legalOptions);

    });

    // Set the cost of the tickets in each price group's html
    $('.price-group-row').each(function() {
      $(this).find('.sum').html($(this).find('select').val() * $(this).find('.price').data('price'));
    });

    // Get the total cost of all tickets
    $('.price-group-row .sum').each(function() {
      totalCost += (+$(this).html());
    });

    // Get the total number of tickets chosen
    $('.price-group-row select').each(function() {
      totalTickets += (+$(this).val());
    });

    // Set the total cost and total tickets in the summary's html
    $('.ticket-table .totalAmount').html(totalTickets + "/" + ticketLimits.reduce(function(a,b){return a+b},0));
    $('.ticket-table .totalSum').html(totalCost);
  });

  function validateCardChecksum(value, pattern) {
    var sum = 0;

    if (!value.match(pattern)) {
      return false;
    }


    for (var i = 1; i <= value.length; i++) {
      var cur = Number(value.charAt(value.length - i));

      if (i % 2 == 0) {
        var tmp = (cur * 2).toString();

        if (tmp.length == 2) {
            sum += Number(tmp.charAt(1));
        }

        sum += Number(tmp.charAt(0));
      } else {
        sum += cur;
      }
    }

    return (sum % 10 == 0);
  }

  function getCardInformation(value) {
    if (value.match(/^4/)) {
      return {pattern: /^(\d{13}|\d{16})$/, name: 'VISA', type: 'visa'};
    } else if (value.match(/^5[12345]/)) {
      return {pattern: /^\d{16}$/, name: 'MasterCard', type: 'mastercard'};
    }
  }

  function validateEmail() {
    var feedback = $('#email_feedback');
    var email1 = $('#email').val();
    var email2 = $('#email_confirmation').val();

    var text = {
        "no": ["Epostene er like", "Epostene er ikke like"],
        "en": ["Emails are equal", "Emails are not equal"]
    }

    if ($('#ticket_type_card').prop('checked')) {
        feedback.text('');
        feedback.attr('class', '');
    } else if (email1 === email2 && email1 != '') {
      feedback.text(text[$('html').attr('lang')][0]);
      feedback.attr('class', 'email_equal');
      return true;
    } else {
      feedback.text(text[$('html').attr('lang')][1]);
      feedback.attr('class', 'email_error');
    }
  }

  function cardEditingFeedback() {
    var input = $(this);
    var value = input.val();
    var info = getCardInformation(input.val());
    var feedback = $('#card_feedback');

    if (info) {
      feedback.text(info['name']);
      feedback.attr('class', 'card_' + info.type);
    }
    else {
      feedback.html('&nbsp;');
      feedback.attr('class', '');
    }
  }

  function finalCardFeedback() {
    var input = $(this);
    var value = input.val();
    var info = getCardInformation(input.val());
    var feedback = $('#card_feedback');

    if (value.match(/^\s*$/)) {
      feedback.html('&nbsp;');
      feedback.attr('class', '');
    } else if (info && validateCardChecksum(value, info.pattern)) {
      feedback.text(info.name);
      feedback.attr('class', 'card_valid card_' + info.type);
    } else {
      var error_message = {
        'no': 'Dette ser ikke ut som et gyldig kortnummer.',
        'en': 'This does not appear to be a valid card number.'
      };

      feedback.text(error_message[$('html').attr('lang')]);
      feedback.attr('class', 'card_error');
    }
  }

  function checkValidForm() {
    var input = $('#ccno');
    var info = getCardInformation(input.val());

    var validEmail = validateEmail();

    if (info && info['type'] !== 'error' &&
        (!$('#ticket_type_paper').prop('checked') ||
        validEmail)) {

      $('.billig-buy .custom-form [name="commit"]').prop('disabled', false);
    }
    else {
      $('.billig-buy .custom-form [name="commit"]').prop('disabled', true);
    }
  }

  $(document).on('focus keyup', '#ccno', cardEditingFeedback);
  $(document).on('blur', '#ccno', finalCardFeedback);
  $(document).on('blur focus keyup change', '.billig-buy .custom-form input', checkValidForm);
});
