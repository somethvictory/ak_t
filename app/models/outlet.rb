class Outlet < ActiveRecord::Base
  validates :label, presence: true
end
