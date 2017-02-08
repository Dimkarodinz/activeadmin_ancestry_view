module ActiveadminAncestryView
  class IndexControllerBuilder < ControllerBuilder
    private

    ORDER_VAR_NAME          = 'i_am_storing_sort_order'
    OLD_SCOPED_COL_VAR_NAME = 'i_am_storing_old_scoped_collection'

    def build_attr_accessor
      %{attr_accessor :#{ORDER_VAR_NAME}}
    end

    def build_before_action
      %{send(:before_action, only: :index) do
          #{save_and_clean_sort_order}
          #{save_old_scoped_collection}
          #{sort_scoped_collection}
        end}
    end

    def build_after_action
      %{send(:after_action, only: :index) do
          #{restore_sort_order}
          #{restore_old_scoped_collection}
        end}
    end

    def save_old_scoped_collection
      "self.class.send :alias_method, :#{OLD_SCOPED_COL_VAR_NAME}, :scoped_collection\n"
    end

    def sort_scoped_collection
      %{self.class.redefine_method(:scoped_collection) do
          ids = #{OLD_SCOPED_COL_VAR_NAME}.all.sort_by(&:full_ancestry).map(&:id)
          resource_class.ordered_collection(ids)
        end}
    end

    def restore_old_scoped_collection
      "self.class.send :alias_method, :scoped_collection, :#{OLD_SCOPED_COL_VAR_NAME}\n"
    end

    def save_and_clean_sort_order
      %{#{ORDER_VAR_NAME} = active_admin_config.sort_order
        active_admin_config.sort_order = ''}
    end

    def restore_sort_order
      %{if #{ORDER_VAR_NAME}
          active_admin_config.sort_order = #{ORDER_VAR_NAME}
          #{ORDER_VAR_NAME} = nil
        end}
    end
  end
end