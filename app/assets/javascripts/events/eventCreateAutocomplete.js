$(function() {
	if (typeof events == "undefined") return;

	var fillFormWithEvent = function fillFormWithEvent(event) {
		$.each(event, function(key, val) {
		    if (key === 'price_type') {
                // Price type is a radio button, so we have to check it manually
                // We also have to specifically add the value (we can't just do "#event_" + key), because
                // #event_price_type also needs the value appended, for example "custom", which gives us
                // #event_price_type_custom.
                document.getElementById("event_" + key + "_" + val).checked = true;
            } else {
                $("#event_" + key).val(val);
            }
		});
	};

	var tokens = $.map(events, function(event) {
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
