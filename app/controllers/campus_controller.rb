class CampusController < ApplicationController

  filter_access_to [:admin], require: :edit

  def admin
    @campuses = Campus.all
  end

  def new
    @campus = Campus.new
  end

  def create
    @campus = Campus.new(params[:campus])
    if @campus.save
      flash[:success] = 'Lagret. Husk å lage translation'
      redirect_to action: :admin
    else
      flash[:message] = 'Oh shit, something wong'
      render :new
    end
  end

  def edit
    @campus = Campus.find(params[:id])
  end

  def show
    @campus = Campus.find(params[:id])
  end

end
