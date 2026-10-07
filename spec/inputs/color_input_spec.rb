# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ColorInput, type: :helper do
  it 'uses the color input type while preserving supplied HTML attributes' do
    object = Event.new
    builder = Formtastic::FormBuilder.new(:event, object, helper, {})
    input = ColorInput.new(builder, helper, object, :event, :primary_color, input_html: { class: 'swatch' })
    expect(input.input_html_options[:type]).to eq('color')
    expect(input.input_html_options[:class]).to include('swatch')
  end
end
