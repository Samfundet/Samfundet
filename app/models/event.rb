# -*- encoding : utf-8 -*-
class Event < ActiveRecord::Base
  AGE_LIMIT = %w(eighteen eighteen_twenty twenty none)
  EVENT_TYPE = %w(art concert course dj excenteraften football_match happening
                  luka_event meeting movie music performance quiz
                  samfundet_meeting party_meeting show theater theme_party uka_event)
  STATUS = %w(active archived canceled)
  PRICE_TYPE = %w(included custom billig free)
  BANNER_ALIGNMENT = %w(left right hide)

  TICKETS_UNAVAILABLE = :tickets_unavailable
  TICKETS_AVAILABLE = :tickets_available
  TICKETS_SOLD_OUT = :tickets_sold_out

  attr_accessible :area_id, :billig_event_id, :title_en, :non_billig_title_no,
                  :non_billig_start_time, :age_limit, :organizer_id, :organizer_type,
                  :short_description_en, :short_description_no, :duration,
                  :long_description_en, :long_description_no, :publication_time,
                  :spotify_uri, :facebook_link, :youtube_link, :youtube_embed, :spotify_link,
                  :soundcloud_link, :instagram_link, :twitter_link, :lastfm_link,
                  :snapchat_link, :vimeo_link, :general_link, :event_type, :status,
                  :primary_color, :secondary_color, :image_id,
                  :price_groups, :price_type, :banner_alignment, :price_groups_attributes

  extend LocalizedFields
  has_localized_fields :title, :short_description, :long_description

  validates_presence_of :title_en, :non_billig_title_no, :non_billig_start_time, :age_limit,
                        :event_type, :status, :area, :organizer, :price_type, :banner_alignment, :image_id
  validates_inclusion_of :age_limit, in: AGE_LIMIT, message: "Invalid age limit"
  validates_inclusion_of :event_type, in: EVENT_TYPE, message: "Invalid type"
  validates_inclusion_of :status, in: STATUS, message: "Invalid status"
  validates_inclusion_of :price_type, in: PRICE_TYPE, message: "Invalid price type"
  validates_inclusion_of :banner_alignment, in: BANNER_ALIGNMENT, message: "Invalid banner alignment"
  validates_inclusion_of :organizer_type, in: [Group.name, ExternalOrganizer.name], message: "Invalid organizer type"
  validates :duration, numericality: { greater_than: 0 }

  validates :primary_color, css_hex_color: true, presence: true
  validates :secondary_color, css_hex_color: true, presence: true

  validates :billig_event_id, uniqueness: true, presence: true, if: -> { price_type.eql? 'billig' }

  belongs_to :area
  belongs_to :organizer, polymorphic: true
  belongs_to :billig_event
  belongs_to :image
  has_one :front_page_lock, as: :lockable
  has_many :price_groups, uniq: true

  accepts_nested_attributes_for :price_groups, allow_destroy: true

  validates_presence_of :price_groups, if: -> { price_type.eql? 'custom' }

  before_save :enforce_price_choice

  scope :active, -> { where(status: 'active')}
  scope :published, -> { where("publication_time < ?", DateTime.current) }
  scope :upcoming, -> { where("non_billig_start_time >= ?", Date.current) }
  scope :past, -> { where("non_billig_start_time < ?", Date.current) }
  scope :today, -> {
    active
    .published
    .where(
      non_billig_start_time:
        (DateTime.current - 4.hours).change(hour: 4)..20.hours.from_now.change(hour: 4))
    .order(:non_billig_start_time)
  }
  scope :by_frontpage_weight, -> {
    active
    .published
    .upcoming
    .sort {|a,b| b.front_page_weight <=> a.front_page_weight }}

  def title_no
    billig_event.try(:event_name) || non_billig_title_no
  end

  def start_time
    billig_event.try(:event_time) || non_billig_start_time
  end

  def end_time
    self.start_time + self.duration.minutes
  end

  def area_title
    billig_event.try(:event_location) || area.name
  end

  include PgSearch
  pg_search_scope :search,
    against: [:non_billig_title_no, :title_en,
              :short_description_no, :short_description_en,
              :long_description_no, :long_description_en,
              :age_limit, :non_billig_start_time,
              :event_type],
    using: {
      tsearch: {
        dictionary: "english",
        prefix: true
      }
    },
    associated_against: { area: :name }

  # Uses the above defined PgSearch scope to perform search.
  def self.text_search query
    if query.present?
      published.includes(:area).search(query)
    else
      []
    end
  end

  def to_s
    title
  end

  def image_or_default
    if image.present?
      image.image_file
    else
      Image.default_image.image_file
    end
  end

  def purchase_status
    return TICKETS_UNAVAILABLE if (billig_event.nil? || Rails.application.config.billig_offline)

    within_sale_period =
      DateTime.current.between?(billig_event.sale_from, billig_event.sale_to)

    netsale_ticket_groups = billig_event.netsale_billig_ticket_groups

    tickets_available = netsale_ticket_groups.any? &:tickets_left?

    if within_sale_period && netsale_ticket_groups.any?
      if tickets_available
        TICKETS_AVAILABLE
      else
        TICKETS_SOLD_OUT
      end
    else
      TICKETS_UNAVAILABLE
    end
  end

  # This function calculates a weight for each event for placement on
  # the frontpage based on time until the event, the event type and
  # the area for the event.
  def front_page_weight
    weight = 50 - 4 * ((start_time - Time.current) / 1.day).to_i

    case event_type
    when "concert"
      weight += 7
    when "theme_party"
      weight += 9
    when "football_match", "dj", "quiz"
      weight += -4*60 # two month's worth of ban
    else
      weight += 0
    end

    case area.name
    when "Storsalen"
      weight += 6
    else
      weight += 0
    end

    case purchase_status
    when TICKETS_SOLD_OUT
      weight += -4 * 30 # one month's worth of ban
    end

    case few_tickets_left?
    when true
      weight += 3
    end

    return weight
  end

  def to_param
    if title.nil?
      super
    else
      "#{id}-#{title.parameterize}"
    end
  end

  def organizer_group_id
    return organizer.id if organizer.is_a? Group
  end

  def organizer_external_name
    return organizer.name if organizer.is_a? ExternalOrganizer
  end

  def price
    case price_type
    when 'included'
      nil
    when 'custom'
      price_groups
    when 'billig'
      unique_price_groups
    when 'free'
      nil
    end
  end

  def self.front_page_events n_front_page_events
    locks = FrontPageLock.locks_enabled
    locks_map = Hash[locks.map {|l| [l.position, l.lockable]}]

    events = Event.active
    .published
    .upcoming
    .includes(:area)
    .sort_by(&:front_page_weight)
    .reverse
    .take(n_front_page_events)

    front_page_events = []
    (0..n_front_page_events).map do |position|
      lockable = locks_map[position]
      front_page_events << lockable
      events -= [lockable]
    end

    front_page_events.map! do |event|
      event.nil? ? events.shift : event
    end

    front_page_events.compact
  end

  # Introducing ghetto polymorphy. Should probably be done differently.
  def enforce_price_choice
    case price_type
    when 'included'
      self.price_groups.clear
      self.billig_event = nil
    when 'custom'
      self.billig_event = nil
    when 'billig'
      self.price_groups.clear
    when 'free'
      self.price_groups.clear
      self.billig_event = nil
    end
  end

  def few_tickets_left?
    if billig_event.present?
      billig_event.billig_ticket_groups.any? &:few_tickets_left
    end
  end

  def cache_key
    "#{super}-#{purchase_status}-#{few_tickets_left?}"
  end

  private

  def unique_price_groups
    unique_price_groups =
      billig_event
      .billig_ticket_groups
      .map(&:netsale_billig_price_groups)
      .flatten
      .uniq(&:price)
  end

end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: events
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  start_time        :datetime
#  short_description :text
#  long_description  :text
#  organizer_id      :integer
#  organizer_name    :string(255)
#  area_id           :integer
#  publication_time  :datetime
#  age_limit         :string(10)
#  spotify_uri       :string(255)
#  event_type        :string(255)
#  status            :string(255)
#
