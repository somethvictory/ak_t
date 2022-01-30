RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.excluded_models = ['Cart', 'CartItem']

  config.model 'Block' do
    weight -2
    navigation_label 'Stock'
  end

  config.model 'Inventory' do
    weight -1
    navigation_label 'Stock'
  end

  config.model 'Order' do
    weight 1
    navigation_label 'Operation'
    list do
      exclude_fields :items
    end
    edit do
      exclude_fields :items
    end
  end

  config.model 'OrderItem' do
    visible false
    weight 2
    navigation_label 'Operation'
    object_label_method do
      :item_sku
    end
    edit do
      exclude_fields :order
    end
  end

  config.model 'Outlet' do
    weight 3
    navigation_label 'Arrangement'
    object_label_method do
      :label
    end
  end

  config.model 'Section' do
    weight 4
    navigation_label 'Arrangement'
    object_label_method do
      :label
    end
  end

  config.model 'SectionItem' do
    weight 5
    navigation_label 'Arrangement'
  end

  config.model 'Menu' do
    weight 6
    navigation_label 'Arrangement'
    object_label_method do
      :label
    end
  end

  config.model 'MenuSection' do
    weight 7
    navigation_label 'Arrangement'
  end

  config.model 'ModifierGroup' do
    weight 8
    navigation_label 'Arrangement'
    object_label_method do
      :label
    end
  end

  config.model 'Modifier' do
    weight 9
    navigation_label 'Arrangement'
    object_label_method do
      :label
    end
  end

  config.model 'Item' do
    weight 10
    navigation_label 'Arrangement'
    object_label_method do
      :sku
    end
  end

  config.model 'ItemModifierGroup' do
    weight 11
    navigation_label 'Arrangement'
  end
end
