class Precinct < ActiveRecord::Base
  # attr_accessible :title, :body
  #set_primary_key :precinct_number
  belongs_to :team
  has_one :precinct_score, :foreign_key => 'precinct_number'
  has_many :shift_details
  attr_accessible :precinct_number, :team_id, :county, :van_precinct_id

  #self.primary_key = :precinct_number

  validates :precinct_number, :presence => true, :uniqueness => {:scope => :county}

  def self.for_select(user)
    select_hash = {}
    counties = self.select("DISTINCT(county)")
    counties.each do |p|
      select_hash[p.county] = self.where(:county => p.county, :state => user.state).order(:precinct_number).map { |p| [p.precinct_number, p.id] }
    end
    return select_hash
  end
end
