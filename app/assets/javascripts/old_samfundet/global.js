jQuery.fn.fadeThenSlideToggle = function(speed, easing, callback) {
  if (this.is(":hidden")) {
    return this.slideDown(speed, easing).fadeTo(speed, 1, easing, callback);
  } else {
    return this.fadeTo(speed, 0, easing).slideUp(speed, easing, callback);
  }
};

function addCloseButtonToFlashMessages() {
  flashElements = $('div[class|=flash]');

  flashElements.find('a.hide').on("click", function () {
    $(this).parent().stop().slideUp();
    return false;
  })

  // Only success-messages should be auto-hidden. We do not want to
  // hide important messages.
  var delay_before_hide_flash_messages = 5000; // ms
  $('div.flash-success').delay(delay_before_hide_flash_messages).fadeThenSlideToggle();
}

function addTooltips(selector) {
  $(selector).tooltip({
    //opacity: 0.8,
    position: "center right",
    offset: [0, 10],
    effect: 'fade'
  });
}

function addLiveSearch(targetListSelector) {
  $('#livesearch').bind("change keyup", function() {
    var list = $(targetListSelector);
    _removeStyling(list)

    var searchWord = $(this).val();
    if (searchWord.length > 0) {
      matches = list.find("li:contains('"+searchWord+"')");
      matches.addClass('match');

      list.find("li").not('.match').addClass('non-match');
    }
  });
}

function _removeStyling(list){
  list.find("li").removeClass('match');
  list.find("li").removeClass('non-match');
}

$(function() { // Called when document is fully loaded
  addCloseButtonToFlashMessages();

  // Commented out until tooltip code is unbroken. See github.
  // addTooltips("[rel='tooltip']");
  //addTooltips("[title]");

  addLiveSearch("#roleslist");

  $("input.member_autocomplete").autocomplete({
    source: "/en/members/search.json",
    minChars: 3
  });

  $("input.applicant_autocomplete").autocomplete({
    source: "/en/applicants/search.json",
    minChars: 3
  });
});

// Tablesorter
$.tablesorter.addParser({
    id: 'link',
    is: function (s) {
        // return false so this parser is not auto detected
        return false;
    },
    format: function (s) {
        return s.toLowerCase().replace(new RegExp(/<.*?>/),"");
    },
    type: 'text'
});
$.tablesorter.addParser({
    id: 'input',
    is: function (s) {
        // return false so this parser is not auto detected
        return false;
    },
    format: function (s, table, cell) {
        var dateString = $(cell).find("input[type='text']").val();
        var dateParts = dateString.replace(new RegExp("[:.]", "g"), " ").split(" ");
        if (dateParts.length != 5) return 0;
        return new Date(dateParts[2], dateParts[1], dateParts[0], dateParts[3], dateParts[4]);
    },
    type: 'numeric'
});

function createSortOrder(i) {
    return {
        "this_job": 5*i,
        "this_job_reserved": 5*i + 1,
        "other_job": 5*i + 2,
        "other_job_reserved": 5*i + 3,
        "no_job": 5*i + 4
    };
}
var sortOrder = {
    "wanted": createSortOrder(0),
    "reserved": createSortOrder(1),
    "not_wanted": createSortOrder(2),
    "": createSortOrder(3)
};
$.tablesorter.addParser({
    id: 'select',
    is: function (s) {
        // return false so this parser is not auto detected
        return false;
    },
    format: function (s, table, cell) {
        return sortOrder[$(cell).find("option:selected").val()][$(cell).closest("tr").attr("class")];
    },
    type: 'numeric'
});
