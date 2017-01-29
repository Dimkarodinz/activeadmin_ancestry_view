require "activeadmin_ancestry_view/engine"
require "activeadmin_ancestry_view/version"
require "activeadmin_ancestry_view/exceptions"
require "activeadmin_ancestry_view/ancestry_view"

require "activeadmin_ancestry_view/finder"
require "activeadmin_ancestry_view/action_generator"
require "activeadmin_ancestry_view/controller_generator"

require "activeadmin_ancestry_view/controller_builder/controller_builder"
require "activeadmin_ancestry_view/controller_builder/index_controller_builder"
require "activeadmin_ancestry_view/controller_builder/show_controller_builder"

require "activeadmin_ancestry_view/action_builder/action_builder"
require "activeadmin_ancestry_view/action_builder/index_action_builder"
require "activeadmin_ancestry_view/action_builder/show_action_builder"

module ActiveadminAncestryView
  ALLOWED_ACTIONS = %w(index show)
end
