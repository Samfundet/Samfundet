# frozen_string_literal: true

module AreasHelper
  def area_link(area, area_name_override = nil)
    if area.page
      link_to (area_name_override || area.name), area.page
    elsif area.name == "Lyche"
      link_to (area_name_override || area.name), sulten_path
    else
      area_name_override || area.name
    end
  end
end
