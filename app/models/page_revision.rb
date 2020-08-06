# frozen_string_literal: true

class PageRevision < ApplicationRecord
  CONTENT_TYPES = %w[html markdown].freeze

  validates :page, presence: true
  validates :content_type, inclusion: { in: CONTENT_TYPES, message: 'Invalid content type' }

  belongs_to :page
  belongs_to :member

  default_scope { order(:version) }
end

# == Schema Information
#
# Table name: page_revisions
#
#  id           :bigint           not null, primary key
#  title_no     :string
#  title_en     :string
#  content_no   :text
#  content_en   :text
#  content_type :string           default("markdown"), not null
#  page_id      :integer          not null
#  version      :integer          default(1), not null
#  member_id    :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
