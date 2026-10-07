# frozen_string_literal: true

# Paperclip 6 passes error options positionally; Rails 6.1 requires keywords.
module PaperclipPresenceKeywords
  def validate_each(record, attribute, _value)
    record.errors.add(attribute, :blank, **options) if record.public_send("#{attribute}_file_name").blank?
  end
end

module PaperclipContentTypeKeywords
  def mark_invalid(record, attribute, types)
    record.errors.add(attribute, :invalid, **options.merge(types: types.join(', ')))
  end
end

Paperclip::Validators::AttachmentPresenceValidator.prepend(PaperclipPresenceKeywords)
Paperclip::Validators::AttachmentContentTypeValidator.prepend(PaperclipContentTypeKeywords)
