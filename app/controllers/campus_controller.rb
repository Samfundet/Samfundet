class CampusController < ApplicationController

  def index
    @campuses = Campus.all
  end

  def new
    @campus = Campus.new
  end

  def create
    @campus = Campus.new(params[:campus])
    if @campus.save
      flash[:success] = 'Lagret. Husk å lage translation'
      redirect_to :index
    else
      flash[:message] = 'Oh shit, something wong'
      render :new
    end
  end

  def show
    @campus = Campus.find(params[:id])
  end

end
