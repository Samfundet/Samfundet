# frozen_string_literal: true

class Sulten::TablesController < Sulten::BaseController
  load_and_authorize_resource

  def index
    @tables = Sulten::Table.order(:number).all
    @neighbour_relations = Sulten::NeighbourTable.all
  end

  def show
    @table = Sulten::Table.find(params[:id])
  end

  def edit
    @table = Sulten::Table.find(params[:id])
    @other_tables = Sulten::Table.where.not(id: @table.id).order(:number).all
  end

  def update
    @table = Sulten::Table.find(params[:id])

    # Add new neighbours
    if not params[:is_neighbour].nil?
      params[:is_neighbour].each do |k, v|
        # If not already a neighbour
        if not @table.is_neighbour?(k.to_i)
          neigh = Sulten::NeighbourTable.new(table_id: @table.id, neighbour_id: k.to_i)
          neigh.save
        end
      end
    end

    # Remove removed neighbours (in both directions)
    # Left associations [my_id, other_id]
    @table.left_neighbour_associations.each do |n|
      # If none selected or not selected this neighbour
      if params[:is_neighbour].nil? or not params[:is_neighbour].include?(n.neighbour_id.to_s)
        puts("DETECTED DELETE LEFT #{n.table_id} #{n.neighbour_id}")
        n.destroy
      end
    end
    # Right associations [other_id, my_id]
    @table.right_neighbour_associations.each do |n|
      # If none selected or not selected this neighbour
      if params[:is_neighbour].nil? or not params[:is_neighbour].include?(n.table_id.to_s)
        puts("DETECTED DELETE RIGHT #{n.table_id} #{n.neighbour_id}")
        n.destroy
      end
    end

    # Save and update other attributes
    if @table.save and @table.update_attributes(table_params)
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
    @other_tables = Sulten::Table.order(:number).all
  end

  def create
    @table = Sulten::Table.new(table_params)


    if @table.save

      # Add new neighbours
      if not params[:is_neighbour].nil?
        params[:is_neighbour].each do |k, v|
          neigh = Sulten::NeighbourTable.new(table_id: @table.id, neighbour_id: k.to_i)
          neigh.save
        end
      end

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
