class ListStatus < ActiveRecord::Base
  belongs_to :list
  belongs_to :organization
  attr_accessible :list_id, :organization_id, :created_by_user_id,  :status, :date
end
