# frozen_string_literal: true

require 'rails_helper'
RSpec.describe UserSessionsHelper, type: :helper do
  %i[no en].each do |locale|
    it "allows padding around the translated #{locale} login placeholder" do
      I18n.with_locale(locale) do
        expect(helper.login_text_input_width).to eq(I18n.t('member_sessions.forms.login.member_login_id').length + 3)
      end
    end
  end
end
