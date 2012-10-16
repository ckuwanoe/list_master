class Region < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :organizers
  has_many :users
  has_many :teams, :through => :organizers

  attr_accessible :region_name, :state
  validates :region_name, :presence => true, :uniqueness => {:scope => :state}
  validates :state, :presence => true
end
