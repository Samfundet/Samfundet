# frozen_string_literal: true

class ColorInput < Formtastic::Inputs::StringInput
  def input_html_options
    super.merge(type: 'color')
  end
end
