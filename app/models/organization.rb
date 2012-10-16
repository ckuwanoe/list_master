class Organization < ActiveRecord::Base
  belongs_to :list_status
  attr_accessible :organization_name
end
