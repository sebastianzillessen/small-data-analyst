class PreferenceArgument < ActiveRecord::Base
  belongs_to :preference
  belongs_to :assumption
  has_many :model_orders, dependent: :destroy, autosave: true
  has_many :models, through: :model_orders

  validates :assumption, presence: true
  validates :model_orders, presence: true

  validates :order_string, presence: true

  # TODO: mutually exclusive assumptions

  def order_string
    self.model_orders.map { |mo| mo.models.map { |m| "model_#{m.id}" }.join(",") }.join(",,")
  end

  def order_string=(models_as_strings)
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

  def rules
    res = [assumption.int_name]
    # add attacks on all edges
    edges_to_be_attacked = []
    model_orders.sort_by { |mo| mo.index }.each do |mo|
      mo.models.each do |lower_module|
        model_orders.includes(:models).select { |higher| higher.index > mo.index }.map(&:models).flatten.each do |higher|
          edges_to_be_attacked << "#{lower_module.int_name} -> #{higher.int_name}"
        end
      end
    end
    edges_to_be_attacked.each do |e|
      res << "#{assumption.int_name} -> (#{e})"
    end

    res
  end
end
