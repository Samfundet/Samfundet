# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationRecord do
  it 'is abstract so subclasses use their own tables' do
    expect(ApplicationRecord).to be_abstract_class
    expect(Group.table_name).to eq('groups')
  end
end
