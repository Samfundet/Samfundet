# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class FrontPageLocksController < ApplicationController
  filter_access_to :all

  def edit
    @front_page_lock = FrontPageLock.where(position: params[:id]).first_or_create!
    @upcoming_events = Event.active.published.upcoming
    @blogs = Blog.published
  end

  def clear
    @front_page_lock = FrontPageLock.find_by(position: params[:id])
    @front_page_lock.lockable = nil

    if @front_page_lock.save
      flash[:success] = t('front_page_lock.clear_success')
      redirect_to root_path
    else
      @upcoming_events = Event.active.published.upcoming
      flash.now[:error] = t('front_page_lock.update_error')
      render :edit
    end
  end

  def update
    @front_page_lock = FrontPageLock.find_by(position: params[:id])

    @front_page_lock.lockable_type = params[:front_page_lock][:lockable_type]
    @front_page_lock.lockable_id =
      case @front_page_lock.lockable_type
      when Event.name
        params[:front_page_lock][:event_id]
      when Blog.name
        params[:front_page_lock][:blog_id]
      end

    if @front_page_lock.save
      flash[:success] = t('front_page_lock.update_success')
      redirect_to root_path
    else
      @upcoming_events = Event.active.published.upcoming
      @blogs = Blog.published
      if !@front_page_lock.errors.include?(:event_id) &&
         !@front_page_lock.errors.include?(:blog_id)
        flash.now[:error] = t('front_page_lock.update_error')
      end
      render :edit
    end
  end
end
