class StockService
  class Error < StandardError; end
  attr_reader :outlet_id, :fulfilment_type, :serving_date_start, :serving_date_end, :timeslot_start, :timeslot_end

  def initialize(params)
    @outlet_id = params[:outlet_id]
    @fulfilment_type = params[:fulfilment_type]
    @serving_date_start = params[:serving_date_start]
    @serving_date_end = params[:serving_date_end]
    @timeslot_start = params[:timeslot_start]
    @timeslot_end = params[:timeslot_end]
  end

  def call
    validate_required_params!

    blocked_inventory_ids = Block.pluck(:inventory_id)

    inventories = Inventory.where(outlet_id: outlet_id, fulfilment_type: fulfilment_type)

    inventories = inventories.where('serving_date_start >= ?', serving_date_start.to_s) if serving_date_start.present?
    inventories = inventories.where('serving_date_end <= ?', serving_date_end.to_s) if serving_date_end.present?
    inventories = inventories.where('timeslot_start >= ?', timeslot_start) if timeslot_start.present?
    inventories = inventories.where('timeslot_end <= ?', timeslot_end) if timeslot_end.present?

    inventories = inventories.where.not(id: blocked_inventory_ids)

    inventories
  end

  private

  def validate_required_params!
    raise(Error, 'outlet_id is missing') if outlet_id.blank?
    raise(Error, 'fulfilment_type is missing') if fulfilment_type.blank?
  end
end