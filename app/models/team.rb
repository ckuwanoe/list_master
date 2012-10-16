class Team < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :organizer
  has_many :precincts
  attr_accessible :team_name, :organizer_id
  validates :team_name, :presence => true, :uniqueness => {:scope => :organizer_id}
  validates :organizer_id, :presence => true

  scope :regions_join,
    joins("LEFT JOIN organizers ON teams.organizer_id = organizers.id LEFT JOIN regions ON organizers.region_id = regions.id")

  def self.by_region(state, region)
    regions_join
    if region > 0
      regions_join.where("regions.state = '#{state}' AND regions.id = #{region}")
    end
  end

  def self.get_region_by_team_id(team)
    regions_join.select("regions.id AS region_id").where("teams.id = #{team}").first.region_id.to_i
  end
end
