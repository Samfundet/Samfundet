# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoBox, type: :model do
  subject(:info_box) do
    described_class.new(
      title_no: 'Velkommen', title_en: 'Welcome',
      body_no: 'Les mer', body_en: 'Read more', color: 'blue',
      start_time: Time.current, end_time: 1.day.from_now, position: 1,
      image: Image.new
    )
  end

  it 'accepts complete attributes' do
    expect(info_box).to be_valid
  end

  %i[title_no title_en body_no body_en color start_time end_time position].each do |attribute|
    it "requires #{attribute}" do
      info_box.public_send("#{attribute}=", nil)

      expect(info_box).not_to be_valid
      expect(info_box.errors[attribute]).to be_present
    end
  end

  describe '#to_s' do
    it 'uses the Norwegian title in the Norwegian locale' do
      I18n.with_locale(:no) { expect(info_box.to_s).to eq('Velkommen') }
    end

    it 'uses the English title in the English locale' do
      I18n.with_locale(:en) { expect(info_box.to_s).to eq('Welcome') }
    end

    it 'falls back to Norwegian when the English title is blank' do
      info_box.title_en = ''
      I18n.with_locale(:en) { expect(info_box.to_s).to eq('Velkommen') }
    end
  end

  describe '#image_or_default' do
    it 'returns the assigned image attachment' do
      expect(Image).not_to receive(:default_image)
      expect(info_box.image_or_default).to eq(info_box.image.image_file)
    end

    it 'returns the default attachment when no image is assigned' do
      info_box.image = nil
      default_image = Image.new
      allow(Image).to receive(:default_image).and_return(default_image)

      expect(info_box.image_or_default).to eq(default_image.image_file)
    end
  end
end
