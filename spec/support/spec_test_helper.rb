# frozen_string_literal: true
module SpecTestHelper
  def login_member(user)
    request.session[:member_id] = user.id
  end

  def login_applicant(applicant)
    request.session[:applicant_id] = applicant.id
  end
end
