# frozen_string_literal: true

class SiteController < ApplicationController
  skip_authorization_check
  before_action :check_active_notifications

  def index
    @todays_events = Event.today
    @upcoming_events = Event.front_page_events(11)
    @banner_event = @upcoming_events.shift
    @opening_hours_url = page_url(Page.find_by_name(t('site.index.opening-hours-page-title')))
    open_admissions = Admission.appliable.includes(
        group_types: { groups: :jobs }
    )
    if open_admissions and not open_admissions.empty?
      @show_admissions_animation = true
    else
      @show_admissions_animation = false
    end
  end

private

  def check_active_notifications
    valid_date = lambda { |from, to| Time.zone.today.between?(from, to) }

    # start_msg = t('site.index.sit_samf_series1')
    # link_text = t('site.index.sit_samf_series2')
    # end_msg = t('site.index.sit_samf_series3')
    # url = 'https://www.youtube.com/watch?v=dUAbqJTqmzQ'
    # external_url = "<br><br><a target=_'blank' rel='noopener noreferrer' href=#{url}>#{link_text}</a>"

    # message = "#{start_msg} #{external_url} #{end_msg}"

    sit_start = Date.new(2020, 3, 6)
    sit_end = Date.new(2020, 4, 1)
    if valid_date.call(sit_start, sit_end)
      # flash[:notice] = message.html_safe
    end

    corona_flash_start = Date.new(2020, 3, 11)
    corona_flash_end = Date.new(2020, 3, 25)
    blog_link = 'https://samfundet.no/blogg/17-korona-virus'
    link = view_context.link_to(t('site.index.corona2'), blog_link)
    msg = t('site.index.corona') + ' ' + link
    if valid_date.call(corona_flash_start, corona_flash_end)
      flash[:notice] = view_context.sanitize(msg)
    end

    coronaH20_flash_start = Date.new(2020, 8, 10)
    coronaH20_flash_end = Date.new(2020, 12, 31)
    blogH20_link = Page.corona_info
    linkH20 = view_context.link_to(t('site.index.corona_H20_2'), blogH20_link)
    msgH20 = t('site.index.corona_H20') + ' ' + linkH20
    if valid_date.call(coronaH20_flash_start, coronaH20_flash_end)
      flash[:notice] = view_context.sanitize(msgH20)
    end
  end
end
