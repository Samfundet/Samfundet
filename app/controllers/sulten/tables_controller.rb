# frozen_string_literal: true

class Sulten::TablesController < Sulten::BaseController
  load_and_authorize_resource

  def index
    @tables = Sulten::Table.order(:number).all
  end

  def show
    @table = Sulten::Table.find(params[:id])
  end

  def edit
    @table = Sulten::Table.find(params[:id])
    @other_tables = Sulten::Table.where.not(id: @table.id).order(:number).all
    puts("HELLO DUDE:::::::::::::")
    puts(@other_tables.map{ |t| t.number })
    puts("HELLO DUDE:::::::::::::")

  end

  def update
    @table = Sulten::Table.find(params[:id])
    puts("UPDATE TABLE::::")
    puts(params)
    if @table.update_attributes(table_params)
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
    @tables = Sulten::Table.order(:number).all
  end

  def create
    @table = Sulten::Table.new(table_params)
    if @table.save
      flash[:success] = t('helpers.models.sulten.table.success.create')
      redirect_to @table
    else
      flash.now[:error] = t('helpers.models.sulten.table.errors.create')
      render :new
    end
  end

private

  def table_params
    params.require(:sulten_table).permit(:number, :capacity, :comment, :available, reservation_type_ids: [])
  end
end
