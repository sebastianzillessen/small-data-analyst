class ModelOrder < ActiveRecord::Base
  belongs_to :preference_argument
  has_and_belongs_to_many :models

  validates :index, uniqueness: {scope: :preference_argument}, presence: true
  validates :preference_argument, presence: true
  validates :models, presence: true

end
