# frozen_string_literal: true
class AreasController < ApplicationController
  filter_access_to :all

  has_control_panel_applet :edit_opening_hours_applet,
                           if: -> { permitted_to? :manage, :areas }

  def edit
    @areas = Area.all
    @area = Area.find(params[:id])
  end

  def update
    @area = Area.find(params[:id])

    if @area.update(area_params)
      flash[:success] = t 'areas.update_success'
      redirect_to edit_area_path @area
    else
      flash.now[:error] = t 'areas.update_failure'
      render :edit
    end
  end

  def edit_opening_hours_applet
    @areas = Area.all
  end

  private

  def area_params
    params.require(:area).permit(:page_id, standard_hours_attributes: [:open, :open_time, :close_time, :day, :id])
  end
end
