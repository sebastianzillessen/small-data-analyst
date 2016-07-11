class ResearchQuestion < ActiveRecord::Base
  default_scope { order('name DESC') }
  has_and_belongs_to_many :models, uniq: true
  has_many :analyses, dependent: :destroy
  belongs_to :user
  validates :name, presence: true, uniqueness: true

end
