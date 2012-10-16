class ListsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @lists =
  end

end
