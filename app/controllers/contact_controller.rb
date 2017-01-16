class ContactController < ApplicationController
  def index
    @contact_form = ContactForm.new
  end

  def create
    @contact_form = ContactForm.new(params[:contact_form])
    if @contact_form.valid?
      SupportRequestMailer.send_request(@contact_form).deliver
      flash[:success] = t('contact.success_message')
      render :success
    else
      flash.now[:error] = t('contact.error_message')
      render :index
    end
  end
end
