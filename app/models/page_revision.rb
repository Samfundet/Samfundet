# -*- encoding : utf-8 -*-
class PageRevision < ActiveRecord::Base
  CONTENT_TYPES = %w(html markdown)

  validates_presence_of :page
  validates_inclusion_of :content_type, in: CONTENT_TYPES, message: "Invalid content type"

  belongs_to :page
  belongs_to :member

  default_scope order(:version)
end
