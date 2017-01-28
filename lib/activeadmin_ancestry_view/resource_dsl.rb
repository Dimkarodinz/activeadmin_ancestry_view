module ActiveadminAncestryView
  module ResourceDSL
    def ancestry_view(action_name = 'index', opt = {}, &block)
      eval active_admin_action(action_name, opt, &block)
      eval active_admin_controller(action_name)
    end

    private

    def active_admin_controller(action_name)
      builder = Finder.get_controller_builder(action_name)
      ControllerGenerator.new(builder).call
    end

    def active_admin_action(action_name, opt = {}, &block)
      builder = Finder.get_action_builder(action_name)
      ActionGenerator.new(builder, opt, &block).call
    end
  end
end