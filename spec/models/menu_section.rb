require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'assocation' do
    it { is_expected.to belong_to(:menu) }
    it { is_expected.to belong_to(:section) }
  end
end