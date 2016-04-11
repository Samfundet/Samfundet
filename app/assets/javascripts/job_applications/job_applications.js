$(function() {
  $(".up, .down").click(function (event) {
    var $this = $(this);
    event.preventDefault();
    $.post(event.currentTarget.action).success(function () {
      var row = $this.parents("tr");
      var priPrev = parseInt(row.prev().find(".priority").text()) || 1;
      var priCur = parseInt(row.find(".priority").text());
      var priNext = parseInt(row.next().find(".priority").text()) || priCur;

      if ($this.hasClass("up")) {
        row.find(".priority").text(priPrev);
        row.prev().find(".priority").text(priCur);
        row.prev().before(row);
      } else {
        row.find(".priority").text(priNext);
        row.next().find(".priority").text(priCur);
        row.next().after(row);
      }
    });
  });
});
