class Dataset < ActiveRecord::Base
  has_many :analysises
  serialize :columns, Array
end
