require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'assocations' do
    it { is_expected.to have_many(:cart_items) }
  end
end