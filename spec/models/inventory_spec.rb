require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'assocations' do
    it { is_expected.to belong_to(:outlet) }
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:modifier) }
  end

  describe 'validations' do
    subject { create(:inventory) }

    it { is_expected.to validate_presence_of(:fulfilment_type) }
    it { is_expected.to validate_uniqueness_of(:item_id).scoped_to([:outlet_id, :modifier_id, :fulfilment_type]) }
  end
end