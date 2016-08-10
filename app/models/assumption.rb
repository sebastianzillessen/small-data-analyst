class Assumption < ActiveRecord::Base
  default_scope { order('name DESC') }

  include IntName
  after_update :int_invalidate_plots
  after_create :int_invalidate_plots

  #TODO: Make Assumption abstract
  #self.abstract_class = true

  has_and_belongs_to_many :required_by, class_name: 'BlankAssumption',
                          join_table: :required_assumptions,
                          foreign_key: :child_id,
                          association_foreign_key: :parent_id,
                          uniq: true


  has_and_belongs_to_many :models, uniq: true
  belongs_to :user
  has_many :preference_arguments, dependent: :destroy
  has_many :reasons, foreign_key: :argument_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true


  def evaluate(analysis)
    raise "Must be overwritten but #{analysis.inspect} did not do so.#"
  end

  def get_queries(analysis)
    []
  end

  def to_s
    "#{name} (#{self.class})"
  end

  def graph_representation(parent)
    ["#{parent.int_name} -> #{self.int_name}"]
  end

  def get_associated_models
    associated_models = required_by.map(&:get_associated_models)
    associated_models << models
    associated_models.flatten.uniq
  end

  def get_all_parents(children=nil)
    if (children.nil? || !children.include?(self))
      if (children.nil?)
        children = []
      else
        children << self
      end
      required_by.each do |r|
        children = r.get_all_parents(children)
      end
    end
    children
  end

  def int_invalidate_plots
    if (self.changed & ['name', 'r_code', 'question']).any?
      self.models.each do |m|
        m.research_questions.each { |r| r.plot.try(:destroy) }
        m.plot.try(:destroy)
      end
    end
  end
end
