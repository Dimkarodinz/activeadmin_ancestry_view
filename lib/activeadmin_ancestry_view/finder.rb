module ActiveadminAncestryView
  class Finder
    class << self
      def get_action_builder(name)
        if_action_valid(name) do
          ResourceDSL.const_get("#{name.to_s.camelize}ActionBuilder").new
        end
      end

      def get_controller_builder(name)
        if_action_valid(name) do
          ResourceDSL.const_get("#{name.to_s.camelize}ControllerBuilder").new
        end
      end

      private

      def if_action_valid(action_name)
        if ALLOWED_ACTIONS.include? action_name.to_s
          yield
        else
          raise ActionError.new(
            I18n.t 'activeadmin_ancestry_view.errors.wrong_action',
                    actions: ALLOWED_ACTIONS.join(', ')
            )
        end
      end
    end
  end
end