class ListStatus < ActiveRecord::Base
  belongs_to :list
  has_many :organizations
  attr_accessible :list_id, :organization_id, :created_by_user_id,  :status, :datetime
end
