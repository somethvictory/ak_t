module Fulfillable
  extend ActiveSupport::Concern

  def fulfilment_type_enum
    { Delivery: 'Delivery', Pickup: 'Pickup' }
  end
end