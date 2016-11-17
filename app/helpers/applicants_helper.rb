# -*- encoding : utf-8 -*-
# frozen_string_literal: true
module ApplicantsHelper
  def facebook_search_link(applicant)
    search_url = "https://www.facebook.com/search/results.php?#{{ q: applicant.full_name }.to_query}"
    link_to t('job_applications.find_on_facebook', name: applicant.full_name), search_url,
            class: 'applicant_facebook'
  end

  def password_reset_link(args = {})
    email = args[:email]
    recovery_hash = args[:recovery_hash]

    if email.nil? || recovery_hash.nil?
      raise 'Email or recovery_hash not supplied.'
    end

    reset_password_url(email: email, hash: recovery_hash)
  end
end
