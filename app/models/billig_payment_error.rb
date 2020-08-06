# frozen_string_literal: true

class BilligPaymentError < ApplicationRecord
  # attr_accessible :error, :failed, :message, :owner_cardno, :owner_email
end

# == Schema Information
#
# Table name: billig_payment_errors
#
#  error        :string
#  failed       :datetime
#  message      :string
#  owner_cardno :integer
#  owner_email  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
