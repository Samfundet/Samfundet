# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /\A.+@[a-z\d\-.]+\.[a-z]{2,}\z/i.match?(value)
      record.errors[attribute] << (options[:message] || 'is not a valid e-mail')
    end
  end
end
