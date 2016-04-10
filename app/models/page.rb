# -*- encoding : utf-8 -*-
class Page < ActiveRecord::Base
  NAME_FORMAT = /_?[0-9]*-?[a-zA-Z][a-zA-Z0-9\-]*/
  MENU_NAME = "_menu".freeze
  INDEX_NAME = "_index".freeze
  TICKETS_NAME = "tickets".freeze
  HANDICAP_INFO_NAME = 'other-info'.freeze
  REVISION_FIELDS = [:title_no, :title_en, :content_no, :content_en, :content_type].freeze

  extend LocalizedFields
  has_localized_fields :title, :name, :content

  validates_format_of :name_no, with: /^#{NAME_FORMAT}$/
  validates_format_of :name_en, with: /^#{NAME_FORMAT}$/
  validates_presence_of :role
  validates :name_no, uniqueness: true
  validates :name_en, uniqueness: true
  belongs_to :role
  has_many :revisions, class_name: PageRevision.name

  attr_accessible :name_no, :name_en, :title_no, :title_en,
                  :content_no, :content_en, :role, :role_id, :created_at, :updated_at,
                  :content_type

  default_scope { order(I18n.locale == :no ? :name_no : :name_en) }

  REVISION_FIELDS.each do |field|
    define_method field do
      instance_variable_get("@#{field}") || revisions.last.try(field) || PageRevision.column_defaults[field.to_s]
    end

    define_method "#{field}=" do |value|
      if value != send(field)
        instance_variable_set("@#{field}", value)
        @revision_fields_updated = true
      end
    end
  end

  before_save do |page|
    page.name_no = page.name_no.downcase
    page.name_en = page.name_en.downcase
  end

  after_save do |page|
    if @revision_fields_updated
      previous_version = revisions.last.try(:version) || 0
      field_values = Hash[REVISION_FIELDS.map { |field| [field, send(field)] }]

      author = Authorization.current_user
      author = nil unless author.is_a? Member

      revisions.create!(field_values.merge(member: author, version: previous_version + 1))

      @revision_fields_updated = false
    end
  end

  include PgSearch
  multisearchable against: [:title_no,
                            :title_en,
                            :content_no,
                            :content_en],
                  additional_attributes: -> (record) { { publish_at: record.created_at } },
                  if: -> (record) { !%w(_menu _index).include? record.name_no }

  def self.find_by_name(name)
    if I18n.locale == :no
      find_by_name_no(name.downcase)
    else
      find_by_name_en(name.downcase)
    end
  end

  def self.find_by_param(id)
    if id =~ NAME_FORMAT
      find_by_name(id)
    else
      find(id)
    end
  end

  def self.index
    find_or_create_by_name_en(name_no: INDEX_NAME, name_en:  INDEX_NAME, role_id: Role.super_user.id)
  end

  def self.menu
    find_or_create_by_name_en(name_no: MENU_NAME, name_en: MENU_NAME, role_id: Role.super_user.id)
  end

  def self.tickets
    find_or_create_by_name_en(name_no: TICKETS_NAME, name_en: TICKETS_NAME, role_id: Role.super_user.id)
  end

  def self.handicap_info
    find_or_create_by_name_en(name_no: HANDICAP_INFO_NAME, name_en: HANDICAP_INFO_NAME, role_id: Role.super_user.id)
  end

  def to_param
    name
  end
end
