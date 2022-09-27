# -*- encoding : utf-8 -*-
# frozen_string_literal: true

# While the Rails 3 default session store is cookie based,
# we cannot use this because we are storing job applications
# in the session and this would overflow a cookie.

# Create the session table with "rake db:sessions:create"
Rails.application.config.session_store :active_record_store, key: '_samf3sessionid', expire_after: 3.day