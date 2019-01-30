# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe Blog do
  before do
    @member = create(:member)
    @image = create(:image)
  end

  it 'has a title_no greater than zero characters' do
    expect do
      create(:blog, title_no: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a title_en greater than zero characters' do
    expect do
      create(:blog, title_en: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a lead_paragraph_no greater than zero characters' do
    expect do
      create(:blog, lead_paragraph_no: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a lead_paragraph_en greater than zero characters' do
    expect do
      create(:blog, lead_paragraph_en: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a conent_no greater than zero characters' do
    expect do
      create(:blog, content_no: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has a conent_en greater than zero characters' do
    expect do
      create(:blog, content_en: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'has an image' do
    expect do
      create(:blog, author_id: @member.id)
    end.to raise_error(ActiveRecord::InvalidForeignKey)
  end
end
