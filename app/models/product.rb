class Product < ApplicationRecord

  validates_presence_of :name, :description
  validates_numericality_of :price_in_cents, greater_than: 0, only_integer: true
end
