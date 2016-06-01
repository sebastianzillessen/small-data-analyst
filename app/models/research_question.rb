class ResearchQuestion < ActiveRecord::Base
  has_and_belongs_to_many :models

  validates :name, presence: true, uniqueness: true

end
