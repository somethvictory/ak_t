require 'rails_helper'

RSpec.describe Menu, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:label) }
  end
end