require 'rails_helper'

RSpec.describe Block, type: :model do

  describe 'validations' do
    subject { create(:block) }

    it { is_expected.to validate_presence_of(:fulfilment_type) }

    context 'when timeslot end is greater than timeslot start' do
      let(:block) { build(:block, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['12:00AM']) }

      it 'raises an exception' do
        expect { block.save! }.to raise_error(ActiveRecord::RecordInvalid)
        expect(block.errors.messages).to eq({timeslot_end: ['Timeslot end cannot be in the past']})
      end
    end

    context 'whe item and modifier are blank' do
      let(:block) { build(:block, item: nil, modifier: nil) }

      it 'raises an exception' do
        expect { block.save! }.to raise_error(ActiveRecord::RecordInvalid)
        expect(block.errors.messages).to eq({base: ['Item or Modifier must be present']})
      end
    end
  end
end