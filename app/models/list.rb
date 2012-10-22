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
    select("DISTINCT(lists.id), lists.list_name, lists.van_list_id, lists.turf_number, precincts.county, precincts.county, precincts.precinct_number,
      regions.region_name, precinct_attributes.precinct_density, list_attributes.doors_count")
      .joins("INNER JOIN precincts ON lists.precinct_id = precincts.id INNER JOIN teams ON precincts.team_id = teams.id
      INNER JOIN organizers ON teams.organizer_id = organizers.id INNER JOIN regions ON organizers.region_id = regions.id
      INNER JOIN precinct_attributes ON precinct_attributes.precinct_id = precincts.id LEFT OUTER JOIN list_attributes ON list_attributes.list_id = lists.id
      LEFT OUTER JOIN list_statuses ON lists.id = list_statuses.list_id")
  end

  def self.get_all_lists_by_day_for_five_days(order,where)
    order = "ORDER BY precincts.county, precincts.precinct_number, lists.turf_number" if order.blank?
    sql = "
      SELECT
        DISTINCT(lists.id), lists.list_name, lists.van_list_id, lists.turf_number, precincts.precinct_number, precincts.county,
        precinct_attributes.precinct_density, list_attributes.doors_count, two_days_ago, one_day_ago, today, one_day_from_now, two_days_from_now
      FROM
        lists
      INNER JOIN
        precincts ON lists.precinct_id = precincts.id
      INNER JOIN
        precinct_attributes ON precinct_attributes.precinct_id = precincts.id
      LEFT OUTER JOIN
        list_attributes ON list_attributes.list_id = lists.id
      LEFT OUTER JOIN
      (
        SELECT
          list_id,
          MAX(two_days_ago) AS two_days_ago,
          MAX(one_day_ago) AS one_day_ago,
          MAX(today) AS today,
          MAX(one_day_from_now) AS one_day_from_now,
          MAX(two_days_from_now) AS two_days_from_now
        FROM
        (
        SELECT
          list_id,
          CASE WHEN list_statuses.date = CURRENT_DATE-2 THEN organization_name ELSE NULL END AS two_days_ago,
          CASE WHEN list_statuses.date = CURRENT_DATE-1 THEN organization_name ELSE NULL END AS one_day_ago,
          CASE WHEN list_statuses.date = CURRENT_DATE THEN organization_name ELSE NULL END AS today,
          CASE WHEN list_statuses.date = CURRENT_DATE+1 THEN organization_name ELSE NULL END AS one_day_from_now,
          CASE WHEN list_statuses.date = CURRENT_DATE+2 THEN organization_name ELSE NULL END AS two_days_from_now
        FROM
          list_statuses
        INNER JOIN
          organizations ON list_statuses.organization_id = organizations.id
        GROUP BY 1,2,3,4,5,6) a
        GROUP BY 1
      ) statuses ON lists.id = statuses.list_id
      #{where}
      #{order}
      "
    lists = self.find_by_sql(sql)
  end

  def latest_status
    status ||= ListStatus.where(:list_id => self.id).order("created_at DESC").first
    status.present? ? "Last #{status.status.humanize} by #{status.organization.organization_name} on #{status.date.strftime("%m/%d")}" : "n/a"
  end

  def current_status
    status ||= ListStatus.where(:list_id => self.id, :date => Time.zone.now).first
    status.present? ? "#{status.status.humanize} by #{status.organization.organization_name}" : "Open"
  end

  def self.bundle_for_organization_and_date(organization_id,date)
    organization = Organization.find(organization_id)
    lists = self.region_and_status_join.where("list_statuses.organization_id = #{organization_id} AND list_statuses.date = '#{date}'")
    lists.each do |list|
      filename = Dir.glob("/Users/eschalon/Dropbox/Obama/gotv_turf/#{Time.now.strftime("%Y-%m-%d")}/#{list.county}/*#{list.precinct_number}*.pdf")
    end
  end

  def self.import_all
    Dir.foreach('/Users/eschalon/Dropbox/vanscraper/2012-10-18_van_csvs/') do |file|
      next if file == '.' or file == '..'
      filename = "/Users/eschalon/Dropbox/vanscraper/2012-10-18_van_csvs/#{file}"
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
