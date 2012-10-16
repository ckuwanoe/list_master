class ListsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @lists = List.region_and_status_join.order("precincts.county, precincts.precinct_number")
  end

end
