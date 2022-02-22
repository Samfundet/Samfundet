# frozen_string_literal: true

module ApplicantsHelper

  def password_reset_link(args = {})
    email = args[:email]
    recovery_hash = args[:recovery_hash]

    if email.nil? || recovery_hash.nil?
      raise 'Email or recovery_hash not supplied.'
    end

    reset_password_url(email: email, hash: recovery_hash)
  end
end
