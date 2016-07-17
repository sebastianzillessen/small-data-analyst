class PreferenceArgument < ActiveRecord::Base
  belongs_to :preference
  belongs_to :assumption
  has_many :model_orders, dependent: :destroy, autosave: true
  has_many :models, through: :model_orders

  validates :assumption, presence: true
  validates :model_orders, presence: true

  validates :order_string, presence: true

  def order_string
    puts "loading order_string with #{self.id} #{model_orders.length}"
    self.model_orders.map { |mo| mo.models.map { |m| "model_#{m.id}" }.join(",") }.join(",,").tap { |x| puts x }
  end

  def order_string=(models_as_strings)
    puts "trigger update with #{models_as_strings}"
    mo=[]
    models_as_strings.split(/,,+/).each_with_index do |stage, index|
      models = Model.where(id: stage.split(",").map { |m| m.gsub(/model_/, "") })
      mo << ModelOrder.new(models: models, index: index, preference_argument: self)
    end
    self.model_orders = mo
  end

  def models_grouped
    models.select("models.*, model_orders.index").group_by(&:index)
  end

  def models_per_index(index)
    models_grouped[index]
  end
end
