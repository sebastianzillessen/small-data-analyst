class Assumption < ActiveRecord::Base
  #TODO: Make Assumption abstract
  #self.abstract_class = true

  has_and_belongs_to_many :required_by, class_name: 'Assumption', join_table: :assumption_attacks, foreign_key: :attacker_id, association_foreign_key: :attacked_id
  has_and_belongs_to_many :models
  belongs_to :user

  validates :name, presence: true, uniqueness: true


  def evaluate_critical(analysis)
    raise 'Must be overwritten'
  end

  def get_critical_queries(analysis)
    []
  end

  def to_s
    "#{name} (#{self.class})"
  end

  def get_associated_models
    associated_models = required_by.map(&:get_associated_models)
    associated_models << models
    associated_models.flatten.uniq
  end
end
