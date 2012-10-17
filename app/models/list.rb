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
end
