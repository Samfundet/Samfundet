# frozen_string_literal: true

class Document < ApplicationRecord
  # attr_accessible :title, :category_id, :uploader_id, :publication_date, :file

  belongs_to :category, class_name: 'DocumentCategory'
  belongs_to :uploader, class_name: 'Member'

  has_attached_file :file,
                    url: '/upload/:class/:attachment/:id_partition/:filename',
                    path: ':rails_root/public/upload/:class/:attachment/:id_partition/:filename'

  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: 'application/pdf' }

  default_scope { order(publication_date: :desc) }

  after_initialize do
    self.publication_date ||= Time.zone.today
  end

  def to_param
    if title.nil?
      super
    else
      "#{id}-#{title.parameterize}"
    end
  end
end

# == Schema Information
#
# Table name: documents
#
#  id                :bigint           not null, primary key
#  title             :string
#  publication_date  :date
#  category_id       :integer
#  uploader_id       :integer
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
