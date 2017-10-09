class Sulten::TablesController < ApplicationController
  filter_access_to [:index, :new, :export], require: :read

  def index
    @tables = Sulten::Table.order(:number).all
  end

  def show
    @table = Sulten::Table.find(params[:id])
  end

  def edit
    @table = Sulten::Table.find(params[:id])
  end

  def update
    @table = Sulten::Table.find(params[:id])
    if @table.update_attributes(params[:sulten_table])
      redirect_to sulten_tables_path
    else
      render :edit
    end
  end

  def destroy
    Sulten::Table.find(params[:id]).destroy
    redirect_to sulten_tables_path
  end

  def new
    @table = Sulten::Table.new
  end

  def create
    puts params
    @table = Sulten::Table.new(params[:sulten_table])
    if @table.save
      flash[:success] = t("helpers.models.sulten.table.success.create")
      redirect_to @table
    else
      flash.now[:error] = t("helpers.models.sulten.table.errors.create")
      render :new
    end
  end
end
