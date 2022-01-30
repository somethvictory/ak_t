require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'assocations' do
    it { is_expected.to belong_to(:cart) }
    it { is_expected.to belong_to(:item) }
  end
end