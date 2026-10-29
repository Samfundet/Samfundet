# -*- encoding : utf-8 -*-
# frozen_string_literal: true

require 'haml'
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


class Haml::Filters::Markdown
  # Haml 6 compiles filters to Temple expressions. Keep the same renderer for
  # template filters and direct calls from PagesHelper.
  def compile(node)
    text = node.value[:text]
    if Haml::Util.contains_interpolation?(text)
      [:dynamic, "::Haml::Filters::Markdown.render(#{Haml::Util.unescape_interpolation(text)})"]
    else
      [:static, self.class.render(text)]
    end
  end

  class << self
    def render(text)
      markdown.render(text)
    end

    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(renderer, extensions)
    end

    def renderer
      @renderer ||= Redcarpet::Render::HTML.new(render_options)
    end

    def render_options
      {
        filter_html: true,
        hard_wrap: true,
        no_styles: true,
        prettify: false,
        safe_links_only: true,
        with_toc_data: false
      }
    end

    def extensions
      {
        autolink: true,
        footnotes: false,
        highlight: true,
        no_intra_emphasis: true,
        quote: true,
        space_after_headers: false,
        strikethrough: true,
        superscript: true,
        tables: true,
        fenced_code_blocks: true
      }
    end
  end

end
