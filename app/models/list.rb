class List < ActiveRecord::Base
  attr_accessible :list_name, :van_list_id, :van_url, :precinct_id
  has_many :list_statuses
  has_many :organizations, :through => :list_statuses
  has_one :precinct

  def self.region_and_status_join
    joins("INNER JOIN precincts ON lists.precinct_id = precincts.id INNER JOIN teams ON precincts.team_id = teams.id
      INNER JOIN organizers ON teams.organizer_id = organizers.id INNER JOIN regions ON organizers.region_id = regions.id
      INNER JOIN list_statuses ON lists.id = list_statuses.list_id")
  end
end
