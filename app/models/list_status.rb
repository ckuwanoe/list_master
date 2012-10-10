class ListStatus < ActiveRecord::Base
  attr_accessible :list_id, :organization_id, :created_by_user_id,  :status, :datetime
end
