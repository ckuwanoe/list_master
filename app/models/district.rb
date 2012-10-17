class District < ActiveRecord::Base
  attr_accessible :precinct_id, :state_senate, :assembly
end
