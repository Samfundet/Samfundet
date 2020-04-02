# frozen_string_literal: true

class DocumentCategory < ApplicationRecord
  has_many :documents, foreign_key: :category_id

  extend LocalizedFields
  localized_fields :title

  def to_s
    title
  end
end

# == Schema Information
#
# Table name: document_categories
#
#  id       :bigint           not null, primary key
#  title_en :string
#  title_no :string
#
