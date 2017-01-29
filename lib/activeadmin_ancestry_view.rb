require "activeadmin_ancestry_view/engine"
require "activeadmin_ancestry_view/version"
require "activeadmin_ancestry_view/resource_dsl"
require "activeadmin_ancestry_view/exceptions"

require "activeadmin_ancestry_view/finder"
require "activeadmin_ancestry_view/resource_dsl/action_generator"
require "activeadmin_ancestry_view/resource_dsl/controller_generator"

require "activeadmin_ancestry_view/resource_dsl/controller_builder/controller_builder"
require "activeadmin_ancestry_view/resource_dsl/controller_builder/index_controller_builder"
require "activeadmin_ancestry_view/resource_dsl/controller_builder/show_controller_builder"

require "activeadmin_ancestry_view/resource_dsl/action_builder/action_builder"
require "activeadmin_ancestry_view/resource_dsl/action_builder/index_action_builder"
require "activeadmin_ancestry_view/resource_dsl/action_builder/show_action_builder"

module ActiveadminAncestryView
  ALLOWED_ACTIONS = %w(index show)
end
