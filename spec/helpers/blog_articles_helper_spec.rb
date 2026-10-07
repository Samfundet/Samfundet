# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BlogArticlesHelper, type: :helper do
  it 'includes locale and articles in the index cache key' do
    blog = build(:blog)
    expect(helper.cache_key_for_blogs_index([blog])).to eq([I18n.locale, 'blogs', [blog]])
  end
  it 'includes the signed-in user in the article cache key' do
    blog = build(:blog)
    user = build(:member)
    helper.define_singleton_method(:current_user) { controller.current_user }
    controller.define_singleton_method(:current_user) { nil }
    allow(helper).to receive(:current_user).and_return(user)
    expect(helper.cache_key_for_blog_show(blog)).to eq([I18n.locale, 'blog_show', blog, user])
  end
end
