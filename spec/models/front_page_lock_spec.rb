# frozen_string_literal: true

require 'rails_helper'
RSpec.describe FrontPageLock do
  it 'requires unique positions and uses position in URLs' do
    lock = FrontPageLock.create!(position: 2)
    expect(lock.to_param).to eq('2')
    expect(FrontPageLock.new(position: 2)).not_to be_valid
    expect(FrontPageLock.new).not_to be_valid
  end
  it 'selects enabled locks in position order' do
    event = create(:event)
    enabled = FrontPageLock.create!(position: 2, lockable: event)
    FrontPageLock.create!(position: 1)
    expect(FrontPageLock.locks_enabled).to eq([enabled])
    expect(enabled.event_or_blog_exists).to be(true)
    expect(enabled.event_or_blog_locked).to be(true)
  end
  %w[Event Blog].each do |type|
    it "reports missing #{type} selections" do
      lock = FrontPageLock.create!(position: 1)
      lock.assign_attributes(lockable_type: type, lockable_id: -1)
      expect(lock).not_to be_valid
      expect(lock.errors[type == 'Event' ? :event_id : :blog_id]).to be_present
    end
    it "prevents pinning the same #{type} twice" do
      object = type == 'Event' ? create(:event) : create(:blog, author: create(:member), image: create(:image))
      FrontPageLock.create!(position: 1, lockable: object)
      other = FrontPageLock.create!(position: 2)
      other.lockable = object
      expect(other).not_to be_valid
      expect(other.errors[type == 'Event' ? :event_id : :blog_id]).to be_present
    end
  end
end
