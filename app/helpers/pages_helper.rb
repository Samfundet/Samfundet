# -*- encoding : utf-8 -*-
module PagesHelper
  def diff(previous, current)
    previous = previous ? previous.scan(/\w+|\W+/) : []
    current  = current  ? current.scan(/\w+|\W+/)  : []

    Diff::LCS.sdiff(previous, current).map do |change|
      case change.action
      when '='
        h(change.new_element)
      when '+'
        "<ins>#{h(change.new_element)}</ins>"
      when '-'
        "<del>#{h(change.old_element)}</del>"
      when '!'
        "<del>#{h(change.old_element)}</del><ins>#{h(change.new_element)}</ins>"
      end
    end.join.html_safe
  end

  def expand_includes(text, seen = Set.new)
    text.gsub(/%include (#{Page::NAME_FORMAT})%/) do
      name = $1

      # prevent infinite recursion by only allowing a page to be included once
      if seen.include? name
        t("pages.already_included", name: name)
      else
        seen.add name

        child = Page.find_by_name(name)

        if child
          expand_includes(child.content, seen)
        else
          t("pages.include_not_found", name: name)
        end
      end
    end
  end

  def render_page_content(content, content_type)
    text = content

    case content_type
    when "markdown"
      text = expand_includes(text || "")
      html = Haml::Filters::Markdown.render text
      html.html_safe
    when "html"
      text.html_safe
    else
      t("pages.invalid_content_type", content_type: content_type)
    end
  end
end
