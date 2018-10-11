# frozen_string_literal: true

module Types
  class AgeLimit < BaseEnum
    value "eighteen", "18+"
    value "eighteen_twenty", "18/20"
    value "twenty", "20"
    value "none", "No age limit"
  end
end
