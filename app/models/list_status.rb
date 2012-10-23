class ListStatus < ActiveRecord::Base
  belongs_to :list
  belongs_to :organization
  attr_accessible :list_id, :organization_id, :created_by_user_id,  :status, :date

  validates :list_id, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :organization_id, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :created_by_user_id, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :status, :presence => true
  validates :date, :presence => true

  def self.group_by_organization
    select("COUNT(DISTINCT(list_id)) AS lists_count, organization_id").group(:organization_id)
  end
end
