class AreasController < ApplicationController
  filter_access_to :all

  has_control_panel_applet :edit_opening_hours_applet,
    if: -> { permitted_to? :manage, :areas }

  def edit
    @areas = Area.all
    @area = Area.find_by_id params[:id]
  end

  def update
    @area = Area.find_by_id params[:id]

    if @area.update_attributes params[:area]
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
end
