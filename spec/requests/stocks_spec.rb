require 'rails_helper'

RSpec.describe 'StockController', type: :request do
  describe '#index' do
    let(:outlet) { create(:outlet) }
    let(:item) { create(:item) }
    let(:modifier) { create(:modifier) }
    let(:fulfilment_type) { 'Delivery' }
    let!(:inventory) { create(:inventory, outlet: outlet, item: item, modifier: modifier, fulfilment_type: fulfilment_type)}
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
    let(:request) { get '/stock', params: params }

    it 'responds available inventory' do
      request

      data = JSON.parse(response.body)

      expect(data.pluck('id')).to eq([inventory.id, inventory1.id, inventory2.id, inventory3.id])
    end

    context 'when outlet_id params is missing' do
      let(:params) { { fulfilment_type: fulfilment_type } }

      it 'responds error message' do
        request

        data = JSON.parse(response.body)

        expect(data['error']).to eq('outlet_id is missing')
      end
    end

    context 'when fulfilment_type params is missing' do
      let(:params) { { outlet_id: outlet.id } }

      it 'responds error message' do
        request

        data = JSON.parse(response.body)

        expect(data['error']).to eq('fulfilment_type is missing')
      end
    end

    context 'when params serving_date_start is present' do
      before do
        params[:serving_date_start] = 3.days.ago
      end

      it 'returns available stocks from serving_date_start' do
        request

        data = JSON.parse(response.body)

        expect(data.pluck('id')).to match_array([inventory1.id])
      end
    end

    context 'when params serving_date_end is present' do
      before do
        params[:serving_date_end] = 2.days.ago
      end

      it 'returns available stocks before serving_date_end' do
        request

        data = JSON.parse(response.body)

        expect(data.pluck('id')).to match_array([inventory2.id])
      end
    end

    context 'when params timeslot_start is present' do
      before do
        params[:timeslot_start] = Timeslot::HOURS['08:00AM']
      end

      it 'returns available stocks from timeslot_start' do
        request

        data = JSON.parse(response.body)

        expect(data.pluck('id')).to match_array([inventory3.id])
      end
    end

    context 'when params timeslot_end is present' do
      before do
        params[:timeslot_end] = Timeslot::HOURS['10:00PM']
      end

      it 'returns available stocks from timeslot_start' do
        request

        data = JSON.parse(response.body)

        expect(data.pluck('id')).to match_array([inventory3.id])
      end
    end

    context 'when item in inventory got blocked' do
      let!(:block) { create(:block, inventory: inventory) }

      it 'responds with non-blocked inventory' do
        request

        data = JSON.parse(response.body)

        expect(data.pluck('id')).to eq([inventory1.id, inventory2.id, inventory3.id])
      end
    end
  end
end