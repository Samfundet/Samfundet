# frozen_string_literal: true

class FrontPageHijacksController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, FrontPageHijack }

  def index
    @current_and_future_front_page_hijacks = FrontPageHijack.current_and_future_front_page_hijacks
  end

  def new
    @front_page_hijack = FrontPageHijack.new(
      shown_from: Time.current,
      shown_to: Time.current + 1.week
    )
  end

  def create
    @front_page_hijack = FrontPageHijack.new(front_page_hijack_params)
    if @front_page_hijack.save
      flash[:success] = I18n.t('front_page_hijack.create_success')
      redirect_to front_page_hijacks_path
    else
      flash.now[:error] = I18n.t('front_page_hijack.create_error')
      render :new
    end
  end

  def edit
    @front_page_hijack = FrontPageHijack.find params[:id]
  end

  def update
    @front_page_hijack = FrontPageHijack.find(params[:id])
    if @front_page_hijack.update_attributes(front_page_hijack_params)
      flash[:success] = I18n.t('front_page_hijack.update_success')
      redirect_to front_page_hijacks_path
    else
      flash.now[:error] = I18n.t('front_page_hijack.update_error')
      render :edit
    end
  end

  def destroy
    @front_page_hijack = FrontPageHijack.find(params[:id])
    @front_page_hijack.destroy
    flash[:success] = I18n.t('front_page_hijack.destroy_success')
    redirect_to front_page_hijacks_path
  end

  def admin_applet; end

  private
  
  def front_page_hijack_params
    params.require(:front_page_hijack).permit(:message_no, :message_en, :shown_from, :shown_to)
  end
end
