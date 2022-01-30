require 'rails_helper'

RSpec.describe Block, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:inventory) }
  end
end