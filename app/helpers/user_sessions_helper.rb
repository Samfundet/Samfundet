# -*- encoding : utf-8 -*-
# frozen_string_literal: true
module UserSessionsHelper
  # Returns the text width (in characters) of the username and password fields
  # for both member and applicant login forms.
  def login_text_input_width
    # Because the padding of a text input element 'steals' space from
    # the placeholder text, we need to add a magic constant here.
    # This is unfortunate, but I believe it is necessary.
    #
    # This particular translation string is currently the longest
    # possible placeholder value. Again, this is an ugly assumption.
    # CSS is stupid.
    t('member_sessions.forms.login.member_login_id').size + 3
  end
end
