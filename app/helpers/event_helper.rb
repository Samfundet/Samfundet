# frozen_string_literal: true

module EventHelper
  def organizer_link(event)
    if event.organizer.is_a? Group
      group_link(event.organizer)
    else
      event.organizer.name
    end
  end

  def t_event_type(event)
    t "events.#{event.event_type}"
  end

  def t_event_age_limit(event)
    t("events.#{event.age_limit}").html_safe
  end

  def from_to_string(event)
    "#{l(event.start_time, format: :time)} - #{l(event.end_time, format: :time)}"
  end

  def inline_event_price(event)
    case event.price_type
    when 'custom'
      event.price
           .sort_by(&:price)
           .map { |p| "#{p.price},- #{p.name}" }
           .join(' / ')
    when 'billig'
      event.price
           .sort_by(&:price)
           .map { |p| "#{p.price},-" }
           .join(' / ')
    when 'free'
      t('events.ticket_free')
    when 'free_registration'
        if event.registration_event
            event.registration_event.plasser
            event.registration_event.slots
        end
    else
      t('events.ticket_included')
    end
  end

  def embed(event)
    youtube_id = event.youtube_embed.split('=').last
    content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}")
  end

  def cache_key_for_event_show(event)
    [I18n.locale, 'event_show', event, current_user]
  end

  def cache_key_for_events_index(events)
    [I18n.locale, 'events_index', events.to_a, Time.current.day]
  end

  def cache_key_for_frontpage_events(events)
    [I18n.locale, 'site/frontpage-empty', events, current_user]
  end

  def cache_key_for_frontpage_event(event, index)
    [I18n.locale, 'frontpage_event', event, index, current_user]
  end

  def cache_key_for_banner_event(event)
    [I18n.locale, 'banner_event', event]
  end
end
