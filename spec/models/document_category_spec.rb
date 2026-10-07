# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DocumentCategory do
  it 'displays the localized title with Norwegian fallback' do
    category = DocumentCategory.new(title_no: 'Dokumenter', title_en: 'Documents')
    I18n.with_locale(:no) { expect(category.to_s).to eq('Dokumenter') }
    I18n.with_locale(:en) { expect(category.to_s).to eq('Documents') }
    category.title_en = ''
    I18n.with_locale(:en) { expect(category.to_s).to eq('Dokumenter') }
  end
end
