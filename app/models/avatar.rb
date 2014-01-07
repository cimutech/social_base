class Avatar < ActiveRecord::Base
  attr_accessible :logo, :avatarable_id, :avatarable_type

  validates_presence_of :logo
  belongs_to :avatarable, :polymorphic => true
end