class ResearchQuestion < ActiveRecord::Base
  default_scope { order('name DESC') }
  has_and_belongs_to_many :models, uniq: true
  has_many :analyses, dependent: :destroy
  has_many :preferences, dependent: :destroy
  belongs_to :user


  validates :name, presence: true, uniqueness: true

  include IntName
  include Plottable
  after_update :int_invalidate_plots
  after_create :int_invalidate_plots


  def graph_representation
    models.map(&:graph_representation)
  end

  private
  def int_invalidate_plots
    if (self.changed & ['name', 'models']).any?
      Model.all.each { |r| r.plot.try(:destroy) }
      self.plot.try(:destroy)
    end
  end
end
