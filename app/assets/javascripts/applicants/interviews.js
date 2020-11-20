// this js is used in the admissions_admin/jobs view of the admissions_admin controller
$(function () {
  var headers = {};

  $(document).on('render_async_load', function(event) {

  $('.datetimepicker').datetimepicker();

  $.tablesorter.addParser({
      id: 'input-text',
      is: function(s) {
          // return false so this parser is not auto detected
          return false;
      },
      format: function(s, table, cell) {
          var input = $(cell).find('input[type=text]')[0];
          return input.value;
      },
      type: 'text'
  });

  $.tablesorter.addParser({
    id: 'input-select',
    is: function(s) {
      return false;
    },
    format: function(s, table, cell) {
      const input = $(cell).find('option:selected')[0];

      // If the interview status selector box has not been set, we now display
      // an empty string. Turns out this means the column won't be sorted.
      // Therefore, return the string representing the "Not set" state so the
      // column actually gets sorted properly. To do this, we just read the 'lang'
      // attribute of the page and return the appropriate string.
      // This also means if some or all are set to 'Not set', then the table won't
      // be sorted as all are the same.
      const theLanguage = $('html').attr('lang');

      if (input.value === "") {
        return theLanguage === "no" ? "Ikke satt" : "Not set";
      }

      return input.value;
    },
    type: 'select'
  });

  headers[$('.interview-time').index()] = { sorter: 'input' };
  headers[$('.location').index()] = { sorter: 'input-text' };
  headers[$('.application-status').index()] = { sorter: 'input-select' };
  headers[$('.open-for-other-positions').index()] = { sorter: 'input-select' };

  $("table.applications.sorted").tablesorter({
      headers: headers,
      sortInitialOrder: "asc"
  });

  $("table.rejected.sorted").tablesorter({
      headers: headers,
      sortList: [[0,0]]
  });

  $("table.roles.sorted").tablesorter({
      headers: headers,
      sortList: [[0,0]]
  });

  $('fieldset.actions').hide();

  $('form.interview').change(function (event) {
      $("table.applications").trigger("update");
      var $that = $(this);
      if ($(event.target).is("input")) {
          $that.find(".status").stop().css("opacity", 1).css("color", "gray").text("Venter ...");
          if (typeof $that.data("sendUpdatesTimer") !== "undefined") {
              clearTimeout($that.data("sendUpdatesTimer"));
          }
          $that.data("sendUpdatesTimer", setTimeout(function () {
              sendUpdates($that);
              $that.data("sendUpdatesTimer", undefined);
          }, 500));
      } else {
          sendUpdates($that);
      }
  });

  function sendUpdates(element) {
      var $status = element.find(".status");
      var $tr = element.closest("tr");
      $status.stop().css("opacity", 1).css("color", "gray").text("Lagrer ...");
      $.post(element.attr("action"), element.serialize())
      .success(function (data) {
          $status.stop().text("Lagret!").animate({opacity: 0}, 1500);
          if (typeof data["status"] != "undefined") {
            $tr.removeClass().addClass(data["status"]);
            refreshTitles();
          }

          if (data["warning"]) {
            $('div.flash.message').html(data["warning"])
                                  .removeClass("hidden");
          } else {
            $('div.flash.message').addClass("hidden");
          }
      })
      .error(function (xhr) {
          $status.css("color", "red").text("Feil: " + xhr.responseText);
      });
  }

  function refreshTitles() {
      $('tr.this_job').attr("title", "Denne personen vil gå til denne stillingen slik ting er satt nå.");
      $('tr.this_job.reserved').attr("title", "Denne personen er reservert for denne stillingen slik ting er satt nå.");
      $('tr.no_job').attr("title", "Denne personen vil ikke gå til noen stillinger slik ting er satt nå, trykk på navnet for mer info.");
      $('tr.other_job').attr("title", "Denne personen vil gå til en annen stilling uten endringer, trykk på navnet for mer info.");
      $('tr.other_job_reserved').attr("title", "Denne personen er reservert for en annen stilling, trykk på navnet for mer info.");
  }

  refreshTitles();

  });
});
