class Analysis < ActiveRecord::Base
  belongs_to :research_question
  belongs_to :dataset
  has_and_belongs_to_many :possible_models, class_name: 'Model'
  validates :research_question, :dataset, presence: true

end
