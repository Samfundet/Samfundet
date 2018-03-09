# frozen_string_literal: true

class ContactController < ApplicationController
  def index
    @contact_form = ContactForm.new
  end
end
