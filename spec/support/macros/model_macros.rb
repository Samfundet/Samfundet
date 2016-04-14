# -*- encoding : utf-8 -*-

module ModelMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_validate_presence_of(*attributes)
      attributes.each do |attribute|
        it "should not be valid without #{attribute}" do
          model = described_class.new
          model.send("#{attribute}=", nil)

          model.should have_at_least(1).errors_on(attribute)
        end
      end
    end
  end
end
