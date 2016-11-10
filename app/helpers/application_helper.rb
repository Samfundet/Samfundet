# -*- encoding : utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  FLASH_TYPES = [:success, :notice, :error, :message, :warning].freeze

  def disable_robots
    content_for(:head) do
      haml_tag :meta, { name: 'robots', content: 'noindex' }
    end
  end

  def set_title(page_title)
    content_for(:title) { page_title }
  end

  def set_open_graph_params(open_graph)
    content_for(:open_graph) do
      capture_haml do
        open_graph.each do |property, content|
          haml_tag :meta, { property: "og:#{property}", content:  content }
        end
      end
    end
  end

  def set_twitter_params(twitter)
    content_for(:twitter) do
      capture_haml do
        twitter.each do |name, content|
          haml_tag :meta, { name: "twitter:#{name}", content:  content }
        end
      end
    end
  end

  def set_and_return_title(page_title)
    set_title page_title
    page_title
  end

  def translate_and_capitalize(text, *args)
    translate(text, *args).capitalize
  end

  def change_language
    return controller.change_language if controller.respond_to? :change_language

    if I18n.locale == :no
      { locale: 'en' }
    else
      { locale: 'no' }
    end
  end

  alias T translate_and_capitalize

  def display_flash(type = nil)
    if type.nil?
      flashes = FLASH_TYPES.collect { |name| display_flash(name) }
      flashes.join
    else
      message = flash[type]
      hide_link = content_tag(:a, "", href: request.url, class: :hide)
      content_tag(:div, hide_link + message, class: "flash #{type}") if flash[type]
    end
  end

  def active_page_class(page, css_class = 'active')
    return { class: css_class } if current_page?(page)
    {}
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:tail) { javascript_include_tag(*args) }
  end

  def typekit_include_tag apikey
    javascript_include_tag("//use.typekit.net/#{apikey}.js") +
      javascript_tag("try{Typekit.load()}catch(e){}")
  end

  def todays_standard_hours
    StandardHour.open_today.includes(:area).order('areas.name')
  end

  def background_image_helper css_class, image, options = {}
    capture_haml do
      haml_tag :div, {
          class: css_class,
          style: "background-image: url(#{asset_path(image.url(options[:size]))})"
} do
        yield if block_given?
      end
    end
  end

  def has_control_panel_applets?
    ControlPanel.applets(request).any?(&:relevant?)
  end

  # Remove this when upgrading to Rails 4.1
  def asset_url asset_name
    URI.join(root_url, asset_path(asset_name))
  end
end
