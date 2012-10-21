class ListStatusesController < ApplicationController
  before_filter :authenticate_user!
    respond_to :html, :js

  def index
    @lists = List.get_all_lists_by_day_for_five_days(nil,nil)
  end

  def new
    @list_status = ListStatus.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: ListsDatatable.new(view_context) }
    end
  end

  def create
    params[:list_status][:date] = date_to_db(params[:list_status][:date])
    params[:list_ids].each do |id|
      list_status = ListStatus.create!(:list_id => id, :date => params[:list_status][:date], :status => params[:list_status][:status],
        :organization_id => params[:list_status][:organization_id], :created_by_user_id => current_user.id, :status => "checked_out" )
      if list_status.errors.present?
        flash[:error] = "Cannot add numbers. Please check your numbers and try again."
        render action: "new"  and return
      end
    end
    redirect_to lists_path, notice: "Successfully assigned packets to org."
  end
end
