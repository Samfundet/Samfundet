# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Then /^I should see an error message$/ do
  selector = ".flash-error"

  should have_selector(selector)

  within(selector) do
    page.text.should_not be_blank
  end
end
