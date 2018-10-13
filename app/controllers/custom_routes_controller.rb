# frozen_string_literal: true

class CustomRoutesController < ApplicationController
  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :custom_routes }

  def admin_applet; end

  def index
    @custom_routes = CustomRoute.all
  end

  def new
    @custom_route = CustomRoute.new
    render :edit
  end

  def create
    @custom_route = CustomRoute.new(custom_routes_params)
    if @custom_route.save
      flash[:success] = t('custom_routes.update_success')
      redirect_to action: :index
    else
      flash.now[:error] = t('custom_routes.update_error')
      render :edit
    end
  end

  def edit
    @custom_route = CustomRoute.find params[:id]
  end

  def update
    @custom_route = CustomRoute.find params[:id]
    if @custom_route.update_attributes(custom_routes_params)
      flash[:success] = t('custom_routes.update_success')
      redirect_to custom_routes_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

  def destroy
    @custom_route = CustomRoute.find params[:id]
    @custom_route.destroy
    flash[:success] = t('crud.destroy_success')
    redirect_to custom_routes_path
  end

  def redirect
    @custom_route = CustomRoute.find_by source: params[:source]
    @page = Page.find_by name: params[:source]

    if @page
      redirect_to @page
    elsif @custom_route
      redirect_to @custom_route.target
    else
      render_not_found
    end
  end

  private

  def custom_routes_params
    params.require(:custom_route).permit(
      :name,
      :source,
      :target,
      :comment
    )
  end
end
