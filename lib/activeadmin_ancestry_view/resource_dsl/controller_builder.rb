module ActiveadminAncestryView
  module ResourceDSL
    class ControllerBuilder
      def self.call
        %{controller do
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
          end}
      end
    end
  end
end
