class ResearchQuestion < ActiveRecord::Base
  has_and_belongs_to_many :models
  has_many :analysises
  belongs_to :user
  validates :name, presence: true, uniqueness: true

end
