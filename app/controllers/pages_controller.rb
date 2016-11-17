# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class PagesController < ApplicationController
  filter_access_to [:index, :new, :create]
  filter_access_to [:show, :edit, :update, :destroy], attribute_check: true,
                                                      load_method: :load_page
  filter_access_to [:admin], require: :edit
  filter_access_to [:graph, :history], require: :edit do
    show_admin?
  end

  has_control_panel_applet :admin_applet,
                           if: -> { show_admin? }

  def index
    @menu = Page.menu
    @page = Page.index
    @show_admin = show_admin?
  end

  def show
    @menu = Page.menu
    @page = Page.find_by_param(params[:id]) || not_found
    @show_admin = show_admin?
  end

  def history
    @page = Page.find_by_param(params[:id]) || not_found
    @revisions = @page.revisions
    @show_admin = show_admin?
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      flash[:success] = t('pages.create_success')
      redirect_to @page
    else
      flash.now[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def edit
    @page = Page.find_by_param(params[:id]) || not_found
  end

  def preview
    @content = params[:content]
    @content_type = params[:content_type]

    render layout: false if request.xhr?
  end

  def update
    @page = Page.find_by_param(params[:id]) || not_found

    unless permitted_to? :edit_non_content_fields, @page
      params[:page].slice!(:title_no, :title_en, :content_no, :content_en)
    end

    if @page.update_attributes(page_params)
      flash[:success] = t('pages.edit_success')
      redirect_to page_url @page
    else
      flash.now[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

  def admin
    @pages = Page.with_permissions_to(:edit)
  end

  def destroy
    @page = Page.find_by_param(params[:id])
    @page.destroy # TODO: Should perhaps set a deleted flag instead of deleting
    flash[:success] = t('pages.destroy_success')
    redirect_to admin_pages_path
  end

  def graph
    @data = build_link_graph
  end

  def admin_applet
  end

  def change_language
    new_route = I18n.locale == :no ? { locale: 'en' } : { locale: 'no' }

    new_route[:id] = I18n.locale == :no ? @page.name_en : @page.name_no if @page

    new_route
  end

  private

  def page_params
    params.require(:page).permit(:name_no, :name_en, :title_no, :title_en, :content_no, :content_en, :content_type, :role_id)
  end

  def load_page
    Page.find_by_param(params[:id])
  end

  def not_found
    raise ActiveRecord::RecordNotFound.new
  end

  def show_admin?
    can_create = permitted_to?(:new, :pages)
    can_edit   = permitted_to?(:edit, :pages) # && Page.with_permissions_to(:edit).present?
    # TODO: Create role for editing group pages
    can_create || can_edit
  end

  def build_link_graph
    urlRegex = /(?<!\!)\[.*?\]\((.*?)\)/

    pages = Page.all

    graph = {}
    pages.each do |page|
      if page.content_no.nil?
        graph[page.name] = []
      else
        filtered_links = page.content_no.scan(urlRegex).map { |link_str| urlFilter link_str.first }
        graph[page.name] = filtered_links.reject(&:nil?)
      end
    end
    graph
  end

  private

  # urlFilter takes something that is supposed to be a link from an infopage
  # It then tries to sanitize and check what it points to and return the best guess.
  def urlFilter(url)
    nameRegex = /^#{Page::NAME_FORMAT}$/

    # check if link matches name spec already
    return url if nameRegex.match url

    if url.start_with? '/'
      # this is an url that leads to somewhere on samfundet.no
      begin
        uri = URI.join(request.protocol + request.host, url)
      rescue
        return url
      end
    else
      begin
        uri = URI(url)
      rescue
        return url
      end
    end

    # We only handle http, https. We also let uris not specifying protocol go trough, since they probably are http.
    unless uri.scheme.nil? || uri.scheme == 'http' || uri.scheme == 'https'
      # This is an url, but we a different protocol than http.
      # drop this url
      return nil
    end

    if uri.host == request.host
      # this is a link that leads to samfundet.no
      begin
        # recognize_path throws 404 if it doesn't find a valid distination
        destination = Rails.application.routes.recognize_path uri.to_s
        if destination[:controller] == 'pages' && destination[:action] == 'show'
          # this is some link that resolves to an info page
          return destination[:id]
        else
          # this is a link that leads to something else than an info page
          return uri.path
        end
      rescue
        # recognizing path failed
        # this link probably doesn't lead anywhere on the page
        return uri.path
      end
    else
      return url
    end
  end
end
