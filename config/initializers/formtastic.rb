# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Formtastic::FormBuilder.i18n_lookups_by_default = true

# Set the default text field size when input is a string. Default is 50
Formtastic::FormBuilder.default_text_field_size = 30

# Should all fields be considered "required" by default
# Defaults to true, see ValidationReflection notes below
Formtastic::FormBuilder.all_fields_required_by_default = false

# Set the string that will be appended to the labels/fieldsets which are required
# It accepts string or procs and the default is a localized version of
# '<abbr title="required">*</abbr>'. In other words, if you configure formtastic.required
# in your locale, it will replace the abbr title properly. But if you don't want to use
# abbr tag, you can simply give a string as below
# Formtastic::FormBuilder.required_string = "(required)"

# Set the string that will be appended to the labels/fieldsets which are optional
# Defaults to an empty string ("") and also accepts procs (see required_string above)
# Formtastic::FormBuilder.optional_string = "(optional)"

# Set the way inline errors will be displayed.
# Defaults to :sentence, valid options are :sentence, :list and :none
# Formtastic::FormBuilder.inline_errors = :list

# Set the method to call on label text to transform or format it for human-friendly
# reading when formtastic is user without object. Defaults to :humanize.
Formtastic::FormBuilder.label_str_method = :titleize

# Set the array of methods to try calling on parent objects in :select and :radio inputs
# for the text inside each @<option>@ tag or alongside each radio @<input>@.  The first method
# that is found on the object will be used.
#
# Defaults to %w(to_label display_name full_name name title username login
#                value to_s)
Formtastic::FormBuilder.collection_label_methods = %w(title_and_author
                                                      display_name login to_s)

# Formtastic by default renders inside li tags the input, hints and then
# errors messages. Sometimes you want the hints to be rendered first than
# the input, in the following order: hints, input and errors. You can
# customize it doing just as below:
# Formtastic::FormBuilder.inline_order = [:hints, :input, :errors]

# Set the default "priority countries" to suit your user base when using as: :country
# Formtastic::FormBuilder.priority_countries = ["Australia", "New Zealand"]

# Specifies if labels/hints for input fields automatically be looked up using I18n.
# Default value: false. Overridden for specific fields by setting value to true,
# i.e. label: true, or hint: true (or opposite depending on initialized value)
# Formtastic::FormBuilder.i18n_lookups_by_default = false

# If you want to subclass FormBuilder to add/change the behavior to suit your needs, you
# can specify the builder class.
# Formtastic::SemanticFormHelper.builder = MyCustomBuilder
