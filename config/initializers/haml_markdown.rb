# -*- encoding : utf-8 -*-
# frozen_string_literal: true

require 'redcarpet'

class CustomRenderer < Redcarpet::Render::HTML
  def link(link, title, content)
    if content == "youtube-embed"
      %(<div class="youtube-wrapper"><iframe class="youtube-embed" src="#{link}" frameborder="0" allowfullscreen></iframe></div>)
    else
      %(<a href="#{link}">#{content}</a>)
    end
  end
end

module Haml::Filters::Markdown
  include Haml::Filters::Base

  markdown_extensions = {
    autolink: true,
    no_intraemphasis: true,
    superscript: true,
    fenced_code_blocks: true,
    tables: true
  }

  render_options = {
    filter_html: true
  }

  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(render_options),
                                     markdown_extensions)

  # using define_method rather than def to keep 'markdown' in scope
  define_method(:render) do |text|
    markdown.render(text)
  end
end
