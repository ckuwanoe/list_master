class List < ActiveRecord::Base
  attr_accessible :list_name, :van_list_id, :van_url, :precinct_id
  has_many :list_statuses
  has_many :organizations, :through => :list_statuses
  belongs_to :precinct

  def self.region_and_status_join
    joins("INNER JOIN precincts ON lists.precinct_id = precincts.id INNER JOIN teams ON precincts.team_id = teams.id
      INNER JOIN organizers ON teams.organizer_id = organizers.id INNER JOIN regions ON organizers.region_id = regions.id
      LEFT OUTER JOIN list_statuses ON lists.id = list_statuses.list_id")
  end

  def latest_status
    status = ListStatus.where(:list_id => self.id).order("created_at DESC").first
    status.present? ? "Last #{status.status.humanize} by #{status.organization.organization_name} on #{status.date.strftime("%m/%d")}" : "n/a"
  end

  def current_status
    status = ListStatus.where(:list_id => self.id, :date => Time.zone.now).first
    status.present? ? "#{status.status.humanize} by #{status.organization.organization_name}" : "Open"
  end

  def region_name
    self.precinct.team.organizer.region.region_name
  end

  def import_file(file)
    CSV.parse(File.open(file), :col_sep => "\t" )[1..-1].each do |row|
      #set vars
      import_van_list_id = row[0].to_i
      import_list_name = row[1].strip
      import_turf_number = row[2].strip.split(" ").last.to_i
      import_doors = row[3].to_i
      breakdown = import_list_name.split(".")
      county = breakdown[0]
      region = breakdown[1]
      precincts = breakdown[2].split("-")

      #create survey response datasets
      precincts.each do |p|
        precinct = Precinct.where(:precinct_number => p.to_i, :county => county).first
        list = self.create!(:list_name => import_list_name, :van_list_id => import_van_list_id, :turf_number => import_turf_number, )
      end
    end
  end
end
