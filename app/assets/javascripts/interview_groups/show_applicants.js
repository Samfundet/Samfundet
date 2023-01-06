// this js is used in the admissions_admin/interview_groups view of the admissions_admin controller
$(function () {
  var headers = {};

  // We must also add datepickers since this is only enabled for static sites
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

  headers[$('.interview-time').index()] = { sorter: 'input' };
  headers[$('.location').index()] = { sorter: 'input-text' };
  headers[$('.application-status').index()] = { sorter: 'input-select' };

  $("table.applications.sorted").tablesorter({
      headers: headers,
      sortInitialOrder: "asc"
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

});
