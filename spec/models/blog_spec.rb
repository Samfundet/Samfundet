# frozen_string_literal: true

# == Schema Information
#
# Table name: blogs
#
#  id                :bigint           not null, primary key
#  title_no          :string
#  content_no        :text
#  author_id         :integer
#  published         :boolean
#  publish_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_id          :integer
#  lead_paragraph_no :text
#  title_en          :string
#  lead_paragraph_en :text
#  content_en        :text
#
require 'rspec'
require 'rails_helper'

describe Blog do
  before do
    @member = create(:member)
    @image = create(:image)
  end

  it 'should have a title_no greater than zero characters' do
    expect do
      create(:blog, title_no: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a title_en greater than zero characters' do
    expect do
      create(:blog, title_en: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a lead_paragraph_no greater than zero characters' do
    expect do
      create(:blog, lead_paragraph_no: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a lead_paragraph_en greater than zero characters' do
    expect do
      create(:blog, lead_paragraph_en: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a conent_no greater than zero characters' do
    expect do
      create(:blog, content_no: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have a conent_en greater than zero characters' do
    expect do
      create(:blog, content_en: '', author_id: @member.id, image_id: @image.id)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should have an image' do
    expect do
      create(:blog, author_id: @member.id)
    end.to raise_error(ActiveRecord::InvalidForeignKey)
  end
end
