module ActiveadminAncestryView
  class IndexControllerBuilder < ControllerBuilder
    def initialize(order_type = :var_to_store_order_type)
      @order_type = order_type
    end

    private

    attr_reader :order_type

    def build_attr_accessor
      %{attr_accessor '#{order_type}'}
    end

    def build_before_action
      %{send(:before_action, only: :index) do
          #{save_and_clean_sort_order}
        end}
    end

    def build_after_action
      %{send(:after_action, only: :index) do
          #{restore_sort_order}
        end}
    end

    def build_methods
      # Order scoped_collection in correct sequence
      %{def scoped_collection
          ids = super.all.sort_by(&:full_ancestry).map(&:id)
          resource_class.ordered_collection(ids)
        end}
    end

    # Saves AA resource sort order order to variable, then clean it
    def save_and_clean_sort_order
      %{#{order_type} = active_admin_config.sort_order
        active_admin_config.sort_order = ''}
    end

    # Restore AA resource sorting settings after rendering content
    def restore_sort_order
      %{if #{order_type}
          active_admin_config.sort_order = #{order_type}
          #{order_type} = nil
        end}
    end
  end
end