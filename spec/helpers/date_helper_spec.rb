# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateHelper, type: :helper do
  describe '#ldate' do
    it 'returns nil for a missing date' do
      expect(helper.ldate(nil)).to be_nil
    end

    it 'formats a date using the current locale' do
      date = Date.new(2026, 10, 6)

      I18n.with_locale(:en) do
        expect(helper.ldate(date)).to eq(I18n.l(date))
      end
    end

    it 'passes a custom format to the date formatter' do
      expect(helper.ldate(Date.new(2026, 10, 6), format: '%Y/%m/%d')).to eq('2026/10/06')
    end
  end
end
