class SectionItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :section
end
