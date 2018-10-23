# frozen_string_literal: true

module DateHelper
  def ldate(date, hash = {})
    date ? l(date, hash) : nil
  end
end
