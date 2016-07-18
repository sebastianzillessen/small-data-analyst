class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :research_question
  has_many :preference_arguments, dependent: :destroy
  has_many :reasons, foreign_key: :argument_id

  validates :name, presence: true, uniqueness: true
  validates :stage, presence: true, :numericality => {:greater_than_or_equal_to => 1}
  validates :preference_arguments, presence: true
  validates :research_question, presence: true
  # TODO: Validate that only models that are applicable on a research question can be used in the preference_arguments


  accepts_nested_attributes_for :preference_arguments,
                                allow_destroy: true

  include IntName

  def arguments
    preference_arguments.includes(:assumption).map(&:assumption)
  end

  def all_rules
    res = {}
    preference_arguments.each { |pa| res[pa.assumption.name] = pa.rules }
    res
  end

  def rules(ass)
    assumptions = [ass].flatten.map do |a|
      if a.is_a? Assumption
        a
      else
        arg = preference_arguments.joins(:assumption).where(assumptions: {name: a})
        if (arg.any?)
          arg.map(&:assumption)
        else
          raise RuntimeError, "Assumption must be of type assumption but was #{a.class} and no assumption with text #{a} could be found"
        end
      end
    end
    pas = preference_arguments.where(assumption_id: assumptions.flatten)
    pas.map(&:rules).flatten
  end
end
