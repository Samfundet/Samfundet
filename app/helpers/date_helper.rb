# -*- encoding : utf-8 -*-
module DateHelper
  def ldate date, hash = {}
    date ? l(date, hash) : nil
  end
end
