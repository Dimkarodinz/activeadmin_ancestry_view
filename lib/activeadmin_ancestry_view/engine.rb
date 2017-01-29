module ActiveadminAncestryView
  class Engine < ::Rails::Engine
    config.to_prepare do
      ActiveAdmin::ResourceDSL.send :include, AncestryView
    end
  end
end
