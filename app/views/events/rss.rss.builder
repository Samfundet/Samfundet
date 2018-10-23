# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title t('events.rss_title')
    xml.description t('events.rss_title')

    @events.each do |event|
      xml.item do
        xml.title event.title
        xml.link event_url(event)
        xml.link rel: :enclosure, title: :image, href: asset_url(event.image_or_default.url(:large)).to_s
        xml.location event.area_title
        xml.agelimit t("events.#{event.age_limit}")
        xml.prices do
          event.price_groups.each do |pg|
            xml.price rel: pg.name, amount: pg.price, currency: :NOK
          end
        end
        xml.description event.short_description
        xml.body event.long_description
        xml.guid event_url(event)
        xml.category t("events.#{event.event_type}")
        xml.pubDate event.start_time.to_formatted_s(:rfc822)
      end
    end
  end
end
