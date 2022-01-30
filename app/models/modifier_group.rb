class ModifierGroup < ActiveRecord::Base
  has_many :modifiers

  validates :label, presence: true
end
