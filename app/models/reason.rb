class Reason < ActiveRecord::Base
  belongs_to :possible_model
  belongs_to :argument, polymorphic: true

  validates :possible_model, presence: true
  validates :argument, presence: true
  validates :stage, presence: true
end
