class List < ActiveRecord::Base
  attr_accessible :list_name, :van_list_id, :van_url, :precinct_id, :turf_number, :doors_count
  has_many :list_statuses
  has_many :organizations, :through => :list_statuses
  belongs_to :precinct

  validates :list_name, :presence => true
  validates :van_list_id, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :precinct_id, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :turf_number, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :doors_count, :presence => true, :numericality => {:greater_than_or_equal_to => 0}

  def self.region_and_status_join
    select("lists.*, precincts.county, precincts.precinct_number, regions.region_name")
      .joins("INNER JOIN precincts ON lists.precinct_id = precincts.id INNER JOIN teams ON precincts.team_id = teams.id
      INNER JOIN organizers ON teams.organizer_id = organizers.id INNER JOIN regions ON organizers.region_id = regions.id
      LEFT OUTER JOIN list_statuses ON lists.id = list_statuses.list_id")
  end

  def latest_status
    status ||= ListStatus.where(:list_id => self.id).order("created_at DESC").first
    status.present? ? "Last #{status.status.humanize} by #{status.organization.organization_name} on #{status.date.strftime("%m/%d")}" : "n/a"
  end

  def current_status
    status ||= ListStatus.where(:list_id => self.id, :date => Time.zone.now).first
    status.present? ? "#{status.status.humanize} by #{status.organization.organization_name}" : "Open"
  end

  def region_name
    self.precinct.team.organizer.region.region_name
  end

  def self.import_all
    Dir.foreach('/Users/eschalon/Dropbox/vanscraper/2012-10-17_van_csvs/') do |file|
      next if file == '.' or file == '..'
      filename = "/Users/eschalon/Dropbox/vanscraper/2012-10-17_van_csvs/#{file}"
      self.import_file(filename)
    end
  end

  def self.import_file(file)
    CSV.parse(File.open(file, "r:ISO-8859-15:UTF-8"), :col_sep => "\t" )[1..-1].each do |row|
      #set vars
      import_van_list_id = row[0].to_i
      import_list_name = row[1].strip.split(" ").first.strip
      import_turf_number = row[1].strip.split(" ").last.to_i
      import_doors = row[2].to_i
      breakdown = import_list_name.split(".")
      county = breakdown[0]
      region = breakdown[1]
      precincts = breakdown[2].split("-")

      #create survey response datasets
      precincts.each do |p|
        precinct = Precinct.where(:precinct_number => p.to_i, :county => county).first
        if precinct.present?
          list = self.create!(:precinct_id => precinct.id, :list_name => import_list_name, :van_list_id => import_van_list_id,
            :turf_number => import_turf_number, :doors_count => import_doors)
        end
      end
    end
  end
end
