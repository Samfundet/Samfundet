# frozen_string_literal: true

class PageRevision < ActiveRecord::Base
  CONTENT_TYPES = %w[html markdown].freeze

  validates :page, presence: true
  validates :content_type, inclusion: { in: CONTENT_TYPES, message: 'Invalid content type' }

  belongs_to :page
  belongs_to :member

  default_scope { order(:version) }
end
