require 'rails_helper'

RSpec.describe StockService, type: :service do
  let(:outlet) { create(:outlet) }
  let(:fulfilment_type) { 'Delivery' }
  let!(:inventory) { create(:inventory, outlet: outlet, fulfilment_type: fulfilment_type) }
  let!(:inventory1) do
     create(:inventory,
            outlet: outlet,
            serving_date_start: 2.days.ago,
            serving_date_end: 2.days.from_now,
            fulfilment_type: fulfilment_type)
  end
  let!(:inventory2) do
     create(:inventory,
            outlet: outlet,
            serving_date_start: 10.days.ago,
            serving_date_end: 5.days.ago,
            fulfilment_type: fulfilment_type)
  end
  let!(:inventory3) do
    create(:inventory,
           outlet: outlet,
           timeslot_start: Timeslot::HOURS['09:00AM'],
           timeslot_end: Timeslot::HOURS['09:00PM'],
           fulfilment_type: fulfilment_type)
  end

  let(:params) { { outlet_id: outlet.id, fulfilment_type: fulfilment_type} }
  let(:service) { described_class.new(params).call }

  it 'returns available stocks' do
    expect(service.pluck(:id)).to match_array([inventory.id, inventory1.id, inventory2.id, inventory3.id])
  end

  context 'when outlet_id params is missing' do
    let(:params) { { fulfilment_type: fulfilment_type } }

    it 'raises an exception' do
      expect { service }.to raise_error(StockService::Error)
    end
  end

  context 'when fulfilment_type params is missing' do
    let(:params) { { outlet_id: outlet.id } }

    it 'raises an exception' do
      expect { service }.to raise_error(StockService::Error)
    end
  end

  context 'when params serving_date_start is present' do
    before do
      params[:serving_date_start] = 3.days.ago
    end

    it 'returns available stocks from serving_date_start' do
      expect(service.pluck(:id)).to match_array([inventory1.id])
    end
  end

  context 'when params serving_date_end is present' do
    before do
      params[:serving_date_end] = 2.days.ago
    end

    it 'returns available stocks before serving_date_end' do
      expect(service.pluck(:id)).to match_array([inventory2.id])
    end
  end

  context 'when params timeslot_start is present' do
    before do
      params[:timeslot_start] = Timeslot::HOURS['08:00AM']
    end

    it 'returns available stocks from timeslot_start' do
      expect(service.pluck(:id)).to match_array([inventory3.id])
    end
  end

  context 'when params timeslot_end is present' do
    before do
      params[:timeslot_end] = Timeslot::HOURS['10:00PM']
    end

    it 'returns available stocks from timeslot_start' do
      expect(service.pluck(:id)).to match_array([inventory3.id])
    end
  end

  context 'when a another outlet in inventory got blocked' do
    let!(:block) { create(:block, inventory: inventory1) }

    it 'returns non-blocked inventory' do
      expect(service.pluck(:id)).to eq([inventory.id, inventory2.id, inventory3.id])
    end
  end
end