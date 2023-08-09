# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless /\A\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,4})+\z/.match?(value)
      record.errors[attribute] << (options[:message] || 'is not a valid e-mail')
    end
  end
end
