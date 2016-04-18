$(function() {
	if (typeof events == "undefined") return;

	var fillFormWithEvent = function fillFormWithEvent(event) {
		$.each(event, function(key, val) {
			$("#event_" + key).val(val);
		});
	};

	var tokens = $.map(events, function(elm) {
		var e = elm.event;
		e.displayName = e.non_billig_title_no + " " + e.created_at;
		return e; 
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
