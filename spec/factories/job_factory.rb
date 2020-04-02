# frozen_string_literal: true

# == Schema Information
#
# Table name: jobs
#
#  id                         :bigint           not null, primary key
#  group_id                   :integer
#  admission_id               :integer
#  title_no                   :string
#  title_en                   :string
#  teaser_no                  :string
#  teaser_en                  :string
#  description_en             :text
#  description_no             :text
#  is_officer                 :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  default_motivation_text_no :text
#  default_motivation_text_en :text
#
FactoryBot.define do
  factory :job do
    title_no { 'Title NO' }
    title_en { 'Title EN' }
    teaser_no { 'Job teaser_no' }
    teaser_en { 'Job teaser_en' }
    description_no { 'Beskrivelse' }
    description_en { 'Description' }
    is_officer { false }
    default_motivation_text_no { 'Standard motivasjonsteks' }
    default_motivation_text_en { 'Default motivation text' }
    group
    admission
    trait :officer do
      is_officer { true }
    end
  end
end
