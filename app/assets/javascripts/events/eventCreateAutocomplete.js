$(function() {
	if (typeof events == "undefined") return;

	var fillFormWithEvent = function fillFormWithEvent(event) {
		$.each(event, function(key, val) {
			$("#event_" + key).val(val);
		});
	};

	var tokens = $.map(events, function(event) {
	  console.log(typeof(event));
	  console.log(event);
		event.displayName = event.non_billig_title_no + " - " + new Date(event.created_at).toDateString();
		return event;
	});

	$(".typeahead")
	.typeahead({
		name: "events",
		local: tokens,
		valueKey: "displayName"
    })
	.on('typeahead:selected', function(e, event) {
		fillFormWithEvent(event);
	});
});
