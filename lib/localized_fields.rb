# frozen_string_literal: true
module LocalizedFields
  def localized_fields(*fields)
    fields.each do |field|
      define_method field do
        if I18n.locale == :no || send("#{field}_en").blank?
          send("#{field}_no")
        else
          send("#{field}_en")
        end
      end
    end
  end
end
