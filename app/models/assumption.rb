class Assumption < ActiveRecord::Base
  default_scope { order('name DESC') }
  #TODO: Make Assumption abstract
  #self.abstract_class = true

  has_and_belongs_to_many :required_by, class_name: 'BlankAssumption',
                          join_table: :required_assumptions,
                          foreign_key: :child_id,
                          association_foreign_key: :parent_id,
                          uniq: true

  has_and_belongs_to_many :attacked_by, class_name: 'Assumption',
                          join_table: :assumption_attacks,
                          foreign_key: :parent_id,
                          association_foreign_key: :child_id,
                          uniq: true

  has_and_belongs_to_many :attacking, class_name: 'Assumption',
                          join_table: :assumption_attacks,
                          foreign_key: :child_id,
                          association_foreign_key: :parent_id,
                          uniq: true

  has_and_belongs_to_many :models, uniq: true
  belongs_to :user

  validates :name, presence: true, uniqueness: true


  def evaluate(analysis)
    raise "Must be overwritten but wasnt for #{self}"
  end

  def evaluate_critical(analysis)
    raise 'Must be overwritten'
  end

  def get_critical_queries(analysis)
    []
  end

  def int_name
    name.parameterize.underscore
  end

  def to_s
    "#{name} (#{self.critical? ? 'critical ' : ''}#{self.class})"
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
end
