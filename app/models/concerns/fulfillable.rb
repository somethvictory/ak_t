module Fulfillable
  extend ActiveSupport::Concern

  def fulfilment_type_enum
    { Deliver: 'Delivery', Pickup: 'Pickup' }
  end
end