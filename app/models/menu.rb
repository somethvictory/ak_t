class Menu < ActiveRecord::Base
  validates :label, presence: true
end
