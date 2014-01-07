class Avatar < ActiveRecord::Base
  attr_accessible :logo, :actor_id

  validates_presence_of :logo
  belongs_to :actor_id
end