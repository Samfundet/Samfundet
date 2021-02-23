class InfoBoxesController < ApplicationController
  skip_authorization_check
  def index
    @info_boxes = InfoBox.all
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
      redirect_to @info_box
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
      redirect_to @info_box
    else
      render :edit
    end
  end

  def destroy
    @info_box = InfoBox.find(params[:id])
    @info_box.destroy
    redirect_to action: "index"
  end

  private
    def info_box_params
      params.require(:info_box).permit(:title, :body)
    end
end
