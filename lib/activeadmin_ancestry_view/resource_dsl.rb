module ActiveadminAncestryView
  module ResourceDSL
    def ancestry_view(name = 'index', opt = {}, &block)

      # TODO: ActionBuilder.call(name, opt, block)
      generate_resource_action(name, opt, &block)

      controller do
        private
        attr_accessor :prev_sort_order

        # Order scoped_collection in correct sequence
        send(:before_action, only: [:index, :show]) do

          # Disable AA sorting on index resource
          prev_sort_order = active_admin_config.sort_order
          active_admin_config.sort_order = ''

          sorted_ids = scoped_collection.all.sort_by(&:full_ancestry).map(&:id)

          # Return correctly sorted ActiveRecord::Relation
          self.class.redefine_method :scoped_collection do
            resource_class.ordered_collection(sorted_ids)
          end

          # For show action
          # self.class.redefine_method :find_resource do
          #   resource_class.where(id: params[:id]).first!
          # end
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
    # TODO: add kinda OOP (SOLID, probably)

    # TODO: add options
    def build_index_action(opt = {}, &block)
      "index as: :block do |res|\n " \
        "#{block.call if block_given?}\n" \
        "render partial: 'activeadmin_ancestry_view/main', locals: { resource: res }\n" \
      "end"
    end

    # TODO: add options
    def build_show_action(opt = {}, &block)
      "show do\n" \
        "#{block.call if block_given?}\n" \
        "sorted = resource.subtree.sort_by(&:full_ancestry)\n" \
        "sorted.each do |res|\n" \
          "render partial: 'activeadmin_ancestry_view/main', locals: { resource: res }\n" \
        "end\n" \
      "end"
    end

    # NOTE: not pretty
    def generate_resource_action(name, opt = {}, &block)
      name = name.to_s
      raise ArgumentError unless ALLOWED_ACTIONS.include?(name)

      action = 
        case name
        when 'index'
          build_index_action(opt, &block)
        when 'show'
          build_show_action(opt, &block)
        end

      eval action
    end
  end
end