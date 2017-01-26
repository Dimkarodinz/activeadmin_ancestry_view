module ActiveadminAncestryView
  module ResourceDSL
    def ancestry_view(action_name = 'index', opt = {}, &block)
      eval active_admin_action(action_name, opt, &block)
      eval ControllerBuilder.call
    end

    private

    def active_admin_action(action_name, opt = {}, &block)
      generator = select_action_generator(action_name)
      ActionBuilder.new(generator, opt, &block).call
    end

    def select_action_generator(action_name)
      case action_name.to_s
      when 'index' then IndexGenerator.new
      when 'show'  then ShowGenerator.new
      else
        raise ActionError.new(
          I18n.t 'activeadmin_ancestry_view.errors.wrong_action',
                 actions: ALLOWED_ACTIONS.join(', ')
          )
      end
    end
  end
end