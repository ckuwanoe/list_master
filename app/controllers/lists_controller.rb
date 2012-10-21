class ListsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @lists = List.get_all_lists_by_day_for_five_days(nil,nil)
  end

  def calendar

  end
end
