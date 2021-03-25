class InfoBoxesController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, InfoBox }

  def index
    @info_boxes = InfoBox.order("start_time")
  end

  def show
    @info_box = InfoBox.find(params[:id])
  end

  def new
    @info_box = InfoBox.new
  end

  def create
    @info_box = InfoBox.new(info_box_params)
    if @info_box.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @info_box = InfoBox.find(params[:id])
  end

  def update
    @info_box = InfoBox.find(params[:id])

    if @info_box.update(info_box_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @info_box = InfoBox.find(params[:id])
    @info_box.destroy
    redirect_to root_path
  end

  def admin_applet
  end

  private
    def info_box_params
      params.require(:info_box).permit(:title_no, :title_en, :body_no, :body_en, :image_id, :image_state,:link_no, :link_en, :color, :start_time, :end_time )
    end
end
