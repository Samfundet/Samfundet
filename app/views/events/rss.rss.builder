# frozen_string_literal: true

xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title t('events.rss_title')
    xml.description t('events.rss_title')

    @events.sort_by(&:start_time).each do |event|
      xml.item do
        image_url = asset_url(event.image_or_default.url(:large)).to_s
        mime = MIME::Types.type_for(image_url.split('?').first).find { |t| t.content_type.start_with?('image/') }

        xml.title event.title
        xml.link event_url(event)
        xml.enclosure url: image_url, type: mime.content_type, length: 0
        xml.media :content, url: image_url, type: mime.content_type if mime
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
        xml.endDate event.end_time.to_formatted_s(:rfc822)
      end
    end
  end
end
