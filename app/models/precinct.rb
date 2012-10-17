class Precinct < ActiveRecord::Base
  # attr_accessible :title, :body
  #set_primary_key :precinct_number
  belongs_to :team
  belongs_to :list
  has_one :precinct_score, :foreign_key => 'precinct_number'
  has_many :shift_details
  attr_accessible :precinct_number, :team_id, :county, :van_precinct_id

  require 'csv'

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

  def self.import_file(file)
    CSV.parse(File.open(file), :col_sep => "," )[1..-1].each do |row|
      #set vars
      row[2].nil? ? import_team_name = 'Unknown' : import_team_name = row[2].strip
      import_county = row[0].strip
      import_precinct = row[1].to_i
      import_state_senate = row[3].strip
      import_assembly = row[4].strip
      import_doors = row[5].to_i

      team = Team.find_or_create_by_team_name(import_team_name) unless import_team_name.match("Unknown")
      puts "updating #{import_team_name}\n"
      if team.present?
        #create survey response datasets
        precinct = self.find_or_create_by_team_id_and_precinct_number_and_county_and_state(team.id,import_precinct,import_county,"NV")
        district = District.create!(:precinct_id => precinct.id, :state_senate => import_state_senate, :assembly => import_assembly)
        precinct_attributes = PrecinctAttribute.create!(:precinct_id => precinct.id, :total_doors => import_doors)
      end
    end
  end
end
