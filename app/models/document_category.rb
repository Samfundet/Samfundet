# frozen_string_literal: true
class DocumentCategory < ActiveRecord::Base
  has_many :documents, foreign_key: :category_id

  extend LocalizedFields
  has_localized_fields :title

  def to_s
    title
  end
end
