# frozen_string_literal: true

module Types
  class Area < Bases::BaseEnum
  end
end

Area.all.each do |area|
  Types::Area.value(area.name.parameterize(separator: '_').upcase, area.name, value: area)
end
