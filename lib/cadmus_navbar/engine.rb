module CadmusNavbar
  class Engine < Rails::Engine
    config.to_prepare do
      CadmusNavbar.clear_navigation_item_model_cache!
    end
  end
end