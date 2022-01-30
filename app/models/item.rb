class Item < ActiveRecord::Base
  validates :sku, presence: true
end
