class ListStatusesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @lists = List.region_and_status_join.order("precincts.county, precincts.precinct_number")
  end

  def new
    @lists = List.region_and_status_join.order("precincts.county, precincts.precinct_number")
    @list_status = ListStatus.new
  end

  def create
    params[:list_status][:date] = date_to_db(params[:list_status][:date])
    @list_status = ListStatus.new(params[:list_status])
    respond_to do |format|
      if @list_status.save
        flash[:success] = 'Successfully entered in numbers'
        format.html { redirect_to lists_path, notice: ''}
      else
        flash[:error] = "Cannot add numbers. Please check your numbers and try again."
        format.html { render action: "new" }
        format.json { render json: @list_status.errors, status: :unprocessable_entity }
      end
    end
  end
end
