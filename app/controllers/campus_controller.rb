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
      flash[:success] = "This should work"
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

  def update
    @campus = Campus.find params[:id]
    if @campus.update_attributes(params[:campus])
      flash[:success] = "Success! Husk translation"
      redirect_to action: :admin
    else
      flash.now[:error] = "Ai, noe gikk galt. Husk translation"
      render :edit
    end
  end

  def activate
    @campus = Campus.find params[:campus_id]
    @campus.update_attributes(active: true)
    redirect_to action: :admin
  end

  def deactivate
    @campus = Campus.find params[:campus_id]
    @campus.update_attributes(active: false)
    redirect_to action: :admin
  end
end
