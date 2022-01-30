require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:order).optional(:true) }
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:modifier) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
  end

  describe 'callbacks' do
    describe 'before_save' do
      describe '#quantity_changed?' do
        let(:item) { create(:item) }
        let!(:inventory) { create(:inventory, item: item, quantity: 100) }
        let!(:order) { create(:order, outlet: inventory.outlet) }

        context 'quantity is added' do
          it 'updates inventory quantity correctly' do
            create(:order_item, item: item, modifier: inventory.modifier, order: order, quantity: 5)

            expect(inventory.reload.quantity).to eq(95)
          end
        end

        context 'quantity is removed' do
          let!(:order_item) { create(:order_item, item: item, modifier: inventory.modifier, order: order, quantity: 5) }

          it 'updates inventory quantity correctly' do
            order_item.update!(quantity: 2)

            expect(inventory.reload.quantity).to eq(98)
          end
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#item_sku' do
      context 'when item is present' do
        let(:item) { create(:item, sku: 'TEST01') }
        let(:order_item) { build(:order_item, item: item) }

        it "returns item's sku" do
          expect(order_item.item_sku).to eq(item.sku)
        end
      end

      context 'when item is not present' do
        let(:order_item) { build(:order_item, item: nil) }

        it 'returns New' do
          expect(order_item.item_sku).to eq('New')
        end
      end
    end
  end
end