class Document < ActiveRecord::Base
  attr_accessible :title, :category_id, :uploader_id, :publication_date, :file

  belongs_to :category, class_name: 'DocumentCategory'
  belongs_to :uploader, class_name: 'Member'

  has_attached_file :file,
                    url: "/upload/:class/:attachment/:id_partition/:filename",
                    path: ":rails_root/public/upload/:class/:attachment/:id_partition/:filename"

  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aapplication\/pdf\Z/ }

  default_scope { order('publication_date DESC') }

  after_initialize do
    self.publication_date ||= Date.today
  end

  def to_param
    if title.nil?
      super
    else
      "#{id}-#{title.parameterize}"
    end
  end
end
