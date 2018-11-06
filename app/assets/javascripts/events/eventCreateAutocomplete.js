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
            } else if (key === 'price_groups') {
		        var insertablePriceGroupItems = []

		        // For each price group, we create the whole HTML necessary to display it in the view.
                val.forEach(function(price_group) {
                    insertablePriceGroupItems.push("" +
                        "<div class=\"nested-fields\">" +
                            "<fieldset class=\"inputs\">" +
                                "<ol>" +
                                    "<li class=\"string input required stringish\" id=\"event_price_groups_attributes_" + price_group.id + "_name_input\">" +
                                        "<label for=\"event_price_groups_attributes_" + price_group.id + "_name\" class=\"label\">" +
                                            "Name" +
                                            "<abbr title=\"Påkrevd\">*</abbr>" +
                                        "</label>" +
                                        "<input value=\"" + price_group.name + "\" placeholder=\"Prisgruppe\" maxlength=\"255\" size=\"30\" id=\"event_price_groups_attributes_" + price_group.id + "_name\" required=\"required\" type=\"text\" name=\"event[price_groups_attributes][" + price_group.id + "][name]\">" +
                                    "</li>" +
                                    "<li class=\"number input required numeric stringish\" id=\"event_price_groups_attributes_" + price_group.id + "_price_input\">" +
                                        "<label for=\"event_price_groups_attributes_" + price_group.id + "_price\" class=\"label\">" +
                                            "Price" +
                                            "<abbr title=\"Påkrevd\">*</abbr>" +
                                        "</label>" +
                                        "<input value=\"" + price_group.price + "\" placeholder=\"Pris (NOK)\" id=\"event_price_groups_attributes_" + price_group.id + "_price\" required=\"required\" step=\"1\" type=\"number\" name=\"event[price_groups_attributes][" + price_group.id + "][price]\">" +
                                    "</li>" +
                                    "<input type=\"hidden\" name=\"event[price_groups_attributes][" + price_group.id + "][_destroy]\" id=\"event_price_groups_attributes_" + price_group.id + "__destroy\" value=\"false\">" +
                                        "<a class=\"remove_fields dynamic\" href=\"#\">Slett denne prisgruppen</a>" +
                                "</ol>" +
                            "</fieldset>" +
                        "</div>");
                });

		        // Append all the price groups to the DOM before the already existing div with class="nested-fields"
		        $(".nested-fields").before(insertablePriceGroupItems)
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
