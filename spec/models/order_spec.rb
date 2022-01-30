require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    subject { build(:order) }

    it { is_expected.to belong_to(:outlet) }
    it { is_expected.to have_many(:order_items) }
    it { is_expected.to have_many(:items).through(:order_items) }
  end

  describe 'validations' do
    subject { build(:order) }

    it { is_expected.to validate_presence_of(:serving_date) }
    it { is_expected.to validate_presence_of(:fulfilment_type) }
  end

  describe 'callbacks' do
    describe '#item_availability' do
      let(:item) { create(:item) }
      let(:modifier) { create(:modifier) }
      let(:outlet) { create(:outlet) }
      let(:fulfilment_type) { 'Delivery' }
      let!(:inventory) { create(:inventory, outlet: outlet, item: item, modifier: modifier, fulfilment_type: fulfilment_type) }
      let!(:order_item) { create(:order_item, item: item, modifier: modifier) }
      let!(:block) { create(:block, outlet: outlet, item: item, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['07:00AM'], fulfilment_type: 'Delivery') }

      context 'when ordering comes from another outlet' do
        let(:outlet1) { create(:outlet) }
        let(:order) { build(:order, outlet: outlet1, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['02:00AM'], fulfilment_type: 'Delivery') }

        it 'allows the order to be created' do
          expect(order.save).to eq(true)
        end
      end

      context 'when ordering comes from another item' do
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['02:00AM'], timeslot_end: Timeslot::HOURS['03:00AM'], fulfilment_type: 'Delivery') }
        let(:order_item1) { create(:order_item) }
        let!(:inventory) { create(:inventory, outlet: outlet, item: order_item1.item, modifier: order_item1.modifier, fulfilment_type: fulfilment_type) }

        before do
          order.order_items = [order_item1]
        end

        it 'allows the order to be created' do
          expect(order.save).to eq(true)
        end
      end

      context 'when ordering is out of blocked ranges' do
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['08:00AM'], timeslot_end: Timeslot::HOURS['09:00AM'], fulfilment_type: 'Delivery') }

        it 'allows the order to be created' do
          expect(order.save).to eq(true)
        end
      end

      context 'when ordering fulfilment_type is different' do
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['02:00AM'], fulfilment_type: 'Pickup') }

        it 'allows the order to be created' do
          expect(order.save).to eq(true)
        end
      end

      context 'when order timeslot_start is within the blocked ranges' do
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['02:00AM'], timeslot_end: Timeslot::HOURS['10:00AM'], fulfilment_type: 'Delivery') }

        before do
          order.order_items = [order_item]
        end

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(['Item or Modifier is blocked'])
        end
      end

      context 'when order timeslot_end is within the blocked ranges' do
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['03:00AM'], fulfilment_type: 'Delivery') }

        before do
          order.order_items = [order_item]
        end

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(['Item or Modifier is blocked'])
        end
      end

      context 'when the item is blocked within a time range' do
        let!(:block) { create(:block, outlet: outlet, item: item, timeslot_start: Timeslot::HOURS['12:00AM'], timeslot_end: Timeslot::HOURS['07:00AM'], fulfilment_type: 'Delivery') }
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['02:00AM'], fulfilment_type: 'Delivery') }

        before do
          order.order_items = [order_item]
        end

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(['Item or Modifier is blocked'])
        end
      end

      context 'when the modifier is blocked within a time range' do
        let!(:block) { create(:block, outlet: outlet, modifier: modifier, timeslot_start: Timeslot::HOURS['12:00AM'], timeslot_end: Timeslot::HOURS['07:00AM'], fulfilment_type: 'Delivery') }
        let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['01:00AM'], timeslot_end: Timeslot::HOURS['02:00AM'], fulfilment_type: 'Delivery') }

        before do
          order.order_items = [order_item]
        end

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(['Item or Modifier is blocked'])
        end
      end
    end

    describe '#inventory_availability' do
      let(:outlet) { create(:outlet) }
      let(:item) { create(:item) }
      let(:modifier) { create(:modifier) }
      let(:order) { build(:order, outlet: outlet, timeslot_start: Timeslot::HOURS['02:00AM'], timeslot_end: Timeslot::HOURS['03:00AM'], fulfilment_type: 'Delivery') }
      let(:order_item) { create(:order_item, item: item, modifier: modifier) }
      let(:fulfilment_type) { 'Delivery' }

      before do
        order.order_items = [order_item]
      end

      context 'when all conditions are satisfied' do
        let!(:inventory) { create(:inventory, outlet: outlet, modifier: modifier, item: item, fulfilment_type: fulfilment_type) }

        it 'allows the order to be created' do
          expect(order.save).to eq(true)
        end
      end

      context 'when item is not part of inventory' do
        let(:outlet1) { create(:outlet) }
        let!(:inventory) { create(:inventory, outlet: outlet1, modifier: modifier, item: item, fulfilment_type: fulfilment_type) }

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(["Following items are not in the inventory: [\"1. #{outlet.label} - #{order_item.item.sku} - #{order_item.modifier.label} - #{fulfilment_type} \"]"])
        end
      end

      context 'when item is not part of inventory' do
        let(:item1) { create(:item) }
        let!(:inventory) { create(:inventory, outlet: outlet, modifier: modifier, item: item1, fulfilment_type: fulfilment_type) }

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(["Following items are not in the inventory: [\"1. #{outlet.label} - #{order_item.item.sku} - #{order_item.modifier.label} - #{fulfilment_type} \"]"])
        end
      end

      context 'when item is not part of inventory' do
        let(:modifier1) { create(:modifier) }
        let!(:inventory) { create(:inventory, outlet: outlet, modifier: modifier1, item: item, fulfilment_type: fulfilment_type) }

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(["Following items are not in the inventory: [\"1. #{outlet.label} - #{order_item.item.sku} - #{order_item.modifier.label} - #{fulfilment_type} \"]"])
        end
      end

      context 'when item is not part of inventory' do
        let(:fulfilment_type1) { 'Pickup' }
        let!(:inventory) { create(:inventory, outlet: outlet, modifier: modifier, item: item, fulfilment_type: fulfilment_type1) }

        it 'does not allow the order to be created' do
          expect(order.save).to eq(false)
          expect(order.errors[:base]).to eq(["Following items are not in the inventory: [\"1. #{outlet.label} - #{order_item.item.sku} - #{order_item.modifier.label} - #{fulfilment_type} \"]"])
        end
      end
    end
  end
end