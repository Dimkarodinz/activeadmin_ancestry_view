module ActiveadminAncestryView
  module ResourceDSL
    def ancestry_view(action_name = 'index', opt = {}, &block)

      create_action(action_name, opt, &block)
  
      controller do
        private

        attr_accessor :prev_sort_order

        # Order scoped_collection in correct sequence
        send(:before_action, only: action_name) do

          # Disable AA sorting on index resource
          prev_sort_order = active_admin_config.sort_order
          active_admin_config.sort_order = ''

          sorted_ids = scoped_collection.all.sort_by(&:full_ancestry).map(&:id)

          # Return correctly sorted ActiveRecord::Relation
          self.class.redefine_method :scoped_collection do
            resource_class.ordered_collection(sorted_ids)
          end
        end

        # Restore AA resource sorting settings after rendering content
        send(:after_action) do
          if prev_sort_order
            active_admin_config.sort_order = prev_sort_order
            prev_sort_order = nil
          end
        end
      end
    end

    private

    def create_action(action_name, opt = {}, &block)
      generator = select_generator(action_name)
      action    = ActionBuilder.call(generator, opt, &block)
      eval action
    end

    def select_generator(action_name)
      case action_name.to_s
      when 'index' then IndexGenerator.new
      when 'show' then ShowGenerator.new
      else
        raise ActionError.new(
          "Wrong action name. " \
          "Try to use #{ALLOWED_ACTIONS.join(' or ')} action"
          )
      end
    end
  end
end