class List < ActiveRecord::Base
  attr_accessible :list_name, :van_list_id, :van_url, :precinct_id
  has_many :list_statuses
  has_many :organizations, :through => :list_statuses
end
