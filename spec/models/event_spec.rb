# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id                    :bigint           not null, primary key
#  non_billig_title_no   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  non_billig_start_time :datetime
#  short_description_no  :text
#  long_description_no   :text
#  organizer_id          :integer          not null
#  area_id               :integer          not null
#  publication_time      :datetime
#  age_limit             :string
#  spotify_uri           :string
#  event_type            :string
#  status                :string
#  billig_event_id       :integer
#  organizer_type        :string
#  facebook_link         :string
#  primary_color         :string
#  secondary_color       :string
#  image_id              :integer
#  price_type            :string
#  title_en              :string
#  short_description_en  :text
#  long_description_en   :text
#  youtube_link          :string
#  spotify_link          :string
#  soundcloud_link       :string
#  instagram_link        :string
#  twitter_link          :string
#  lastfm_link           :string
#  snapchat_link         :string
#  vimeo_link            :string
#  general_link          :string
#  banner_alignment      :string
#  duration              :integer          default(120)
#  youtube_embed         :string
#  codeword              :string           default("")
#  feedback_survey_id    :integer
#  has_survey            :boolean
#
require 'rspec'
require 'rails_helper'

describe Event do
  it 'should throw exception when created without a publication time' do
    expect do
      create(:event, publication_time: nil)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
