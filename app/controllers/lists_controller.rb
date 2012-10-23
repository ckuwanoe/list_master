class ListsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @lists = List.get_all_lists_by_day_for_five_days(nil,nil)
  end

  def calendar

  end

  def dashboard
    @lists = ListStatus.group_by_organization.where(:date => Time.zone.now.strftime("%Y-%m-%d"))
  end
end
