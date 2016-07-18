class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :research_question
  has_many :preference_arguments, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :stage, presence: true
  validates :preference_arguments, presence: true
  validates :research_question, presence: true
  # TODO: Validate that only models that are applicable on a research question can be used in the preference_arguments


  accepts_nested_attributes_for :preference_arguments,
                                allow_destroy: true

  include IntName
end
