require 'rails_helper'

RSpec.describe ItemModifierGroup, type: :model do
  describe 'assocations' do
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:modifier_group) }
  end
end