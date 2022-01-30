require 'rails_helper'

RSpec.describe SectionItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:section) }
    it { is_expected.to belong_to(:item) }
  end
end