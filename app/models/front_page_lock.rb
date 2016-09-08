# -*- encoding : utf-8 -*-
class FrontPageLock < ActiveRecord::Base
  BANNER_ID = 0

  belongs_to :lockable, polymorphic: true, touch: true

  #attr_accessible :lockable_id, :lockable_type, :position, :event_id, :blog_id
  attr_accessor :event_id, :blog_id

  validate :check_if_already_locked, on: :update, if: :lockable_type?
  validates :position, presence: true, uniqueness: true
  validates :lockable_id, uniqueness: true, presence: true, if: :lockable_id?
  validates_inclusion_of :lockable_type,
                         in: [Event.name, Blog.name],
                         message: "Invalid lock type",
                         if: :lockable_type?

  # TODO: this might not be an issue in rails 3
  # belongs_to touch: true does not currently touch the old associated
  # object when the foreign key is the value that changes.
  # See rails issue #10197 and friends
  # before_save :update_old_association
  # def update_old_association
  #  if lockable_changed? && lockable_was.present?
  #    lockable_was.touch
  #  end
  # end

  def self.locks_enabled
    where('lockable_id IS NOT null').reject { |a| a.lockable_type == "Event" && a.lockable.end_time < 2.hours.from_now }
  end

  def to_param
    position
  end

  def event_or_blog_exists
    !lockable_type.constantize.find_by_id(lockable_id).nil?
  end

  def event_or_blog_locked
    !lockable_type.constantize.find_by_id(lockable_id).front_page_lock.nil?
  end

  def check_if_already_locked
    if !event_or_blog_exists
      if lockable_type == "Event"
        errors.add(:event_id, I18n.t("activerecord.models.front_page_lock.event_empty_choice_error"))
      else
        errors.add(:blog_id, I18n.t("activerecord.models.front_page_lock.blog_empty_choice_error"))
      end
      return

    elsif event_or_blog_locked
      if lockable_type == "Event"
        errors.add(:event_id, I18n.t("activerecord.models.front_page_lock.event_already_locked_error"))
      else
        errors.add(:blog_id, I18n.t("activerecord.models.front_page_lock.blog_already_locked_error"))
      end
    end
  end
end
# == Schema Information
#
# Table name: front_page_locks
#
#  id         :integer          not null, primary key
#  lockable_id:integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :integer
#  lockable_type :string
