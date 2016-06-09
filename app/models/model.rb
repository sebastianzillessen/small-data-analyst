class Model < ActiveRecord::Base
  has_and_belongs_to_many :research_questions
  has_and_belongs_to_many :analysises

  validates :name, presence: true, uniqueness: true
  validates :research_questions, presence: true

end
