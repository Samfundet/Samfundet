require 'rails_helper'

RSpec.describe Feedback::FeedbackController, :type => :controller do

  describe "GET #inquire" do
    it "returns http success" do
      get :inquire
      expect(response).to have_http_status(:success)
    end
  end

end
