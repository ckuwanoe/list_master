class ListsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @lists = List.region_and_status_join.order("precincts.county, precincts.precinct_number")
  end

  def calendar

  end
end
