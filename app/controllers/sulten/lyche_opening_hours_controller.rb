class Sulten::LycheOpeningHoursController < ApplicationController
  def index
    @lyche_opening_hours= Sulten::LycheOpeningHours.order(:id).all
    @weekdays = ["Sondag","Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lordag"]
  end

  def edit
    @lyche_opening_hours= Sulten::LycheOpeningHours.find(params[:id])
    @weekdays = ["Sondag","Mandag", "Tirsdag", "Onsdag", "Torsdag", "Fredag", "Lordag"]
  end

  def update
    @lyche_opening_hours= Sulten::LycheOpeningHours.find(params[:id])
    if @lyche_opening_hours.update_attributes!(params[:sulten_lyche_opening_hours])
      flash[:success] = "Update successful."
      redirect_to sulten_lyche_opening_hours_path
    else
      flash.now[:error] = "Oops, noe gikk galt."
      redirect_to sulten_lyche_opening_hours_path
    end
  end

  def create
    @lyche_opening_hours = Sulten::LycheOpeningHours.new(params[:sulten_lyche_opening_hours])
    if @lyche_opening_hours.save
      flash[:success] = "Du lagde en ny apningsdag."
    else
      flash.now[:error] = "Oops, noe gikk galt."
    end
  end
end
