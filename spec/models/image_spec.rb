# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image do
  it 'requires a title and an attachment' do
    image = Image.new
    expect(image).not_to be_valid
    expect(image.errors[:title]).to be_present
    expect(image.errors[:image_file]).to be_present
  end
  it 'normalizes tag names and reuses existing tags' do
    image = create(:image)
    tag = Tag.create!(name: 'music')
    image.tagstring = 'Music, Concert'
    expect(image.tags).to include(tag)
    expect(image.tags.pluck(:name)).to contain_exactly('music', 'concert')
    expect(image.tagstring).to eq('music, concert')
  end
  it 'generates readable URLs and display titles' do
    image = Image.new(id: 42, title: 'Concert Photo')
    expect(image.to_param).to eq('42-concert-photo')
    expect(image.to_s).to eq('Concert Photo')
    image.title = nil
    expect(image.to_param).to eq('42')
  end
  it 'reuses the default image' do
    image = Image.default_image
    expect { expect(Image.default_image).to eq(image) }.not_to change(Image, :count)
  end
  it 'uses an assigned image or the default' do
    image = Image.new
    expect(Image.image_for(double(image: image))).to eq(image)
    default = Image.new
    allow(Image).to receive(:default_image).and_return(default)
    expect(Image.image_for(nil)).to eq(default)
  end
  it 'returns all images for an empty search and delegates nonempty searches' do
    image = create(:image)
    expect(Image.text_search(nil)).to contain_exactly(image)
    expect(Image).to receive(:search).with('concert').and_return([image])
    expect(Image.text_search('concert')).to eq([image])
  end
end
