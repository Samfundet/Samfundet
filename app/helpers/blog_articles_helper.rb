# frozen_string_literal: true
module BlogArticlesHelper
  def cache_key_for_blogs_index(blogs)
    [I18n.locale, 'blogs', blogs.to_a]
  end

  def cache_key_for_blog_show(blog)
    [I18n.locale, 'blog_show', blog, current_user]
  end
end
