# frozen_string_literal: true

module FrontPageHijackHelper
  def active_front_page_hijack?
    FrontPageHijack.current_front_page_hijack
  end
end
