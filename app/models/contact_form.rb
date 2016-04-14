# -*- encoding : utf-8 -*-
class ContactForm
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  attr_accessor :name, :email, :problem_type, :subject, :description
  validates :name, :email, :problem_type, :subject, :description, presence: true
  validates :email, email: true

  validates :description, length: { minimum: 50 }
  validates :subject, length: { maximum: 78 }
  EMAILS = ['post@samfundet.no', 'redaksjon@samfundet.no', 'post@samfundet.no', 'mg-web@samfundet.no'].freeze

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def recipient
    EMAILS[problem_type.to_i]
  end

  def persisted?
    false
  end
end
