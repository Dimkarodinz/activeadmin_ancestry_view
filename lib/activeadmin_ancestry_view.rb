require "activeadmin_ancestry_view/engine"
require "activeadmin_ancestry_view/version"
require "activeadmin_ancestry_view/resource_dsl"
require "activeadmin_ancestry_view/exceptions"

require "activeadmin_ancestry_view/resource_dsl/action_builder"
require "activeadmin_ancestry_view/resource_dsl/action_generator"
require "activeadmin_ancestry_view/resource_dsl/action_generator/index_generator"
require "activeadmin_ancestry_view/resource_dsl/action_generator/show_generator"

module ActiveadminAncestryView
  ALLOWED_ACTIONS = %w(index show)
end
