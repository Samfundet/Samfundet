# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobTag do
  it 'can be shared across jobs without merging their associations' do
    first = create(:job)
    second = create(:job)
    first.tag_titles = 'music'
    second.tag_titles = 'music, concert'
    tag = JobTag.find_by!(title: 'music')
    expect(first.tags).to include(tag)
    expect(second.tags).to include(tag)
    first.tags.clear
    expect(second.reload.tags).to include(tag)
  end
end
