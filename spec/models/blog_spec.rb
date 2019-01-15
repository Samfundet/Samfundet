# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe Blog do

  before do
    @member = create(:member)
    @image = create(:image)
  end

  it 'should have a title_no greater than zero characters' do
    expect {
      create(:blog, title_no: "", author_id: @member.id, image_id: @image.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a title_en greater than zero characters' do
    expect {
      create(:blog, title_en: "", author_id: @member.id, image_id: @image.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a lead_paragraph_no greater than zero characters' do
    expect {
      create(:blog, lead_paragraph_no: "", author_id: @member.id, image_id: @image.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a lead_paragraph_en greater than zero characters' do
    expect {
      create(:blog, lead_paragraph_en: "", author_id: @member.id, image_id: @image.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a conent_no greater than zero characters' do
    expect {
      create(:blog, content_no: "", author_id: @member.id, image_id: @image.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a conent_en greater than zero characters' do
    expect {
      create(:blog, content_en: "", author_id: @member.id, image_id: @image.id)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have an image' do
    expect {
      create(:blog, author_id: @member.id)
    }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

end