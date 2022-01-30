require 'rails_helper'

RSpec.describe ModifierGroup, type: :model do
  describe 'assocations' do
    it { is_expected.to have_many(:modifiers)}
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:label) }
  end
end