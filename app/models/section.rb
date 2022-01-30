class Section < ActiveRecord::Base
  validates :label, presence: true
end
