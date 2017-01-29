module ActiveAdmin
  module ActiveadminAncestryView
    module NodesHelper
      CLASSES = { child:  'panel-childless',
                  parent: 'panel-parent' }

      PRETTY_COLORS = { red:    [255, 102, 102], yellow: [255, 178, 102],
                        green:  [102, 255, 102], blue:   [102, 178, 255], 
                        violet: [178, 102, 255], gray:   [192, 192, 192] }

      def generate_panel_classes(resource)
        attributes = []
        attributes << resource.path_ids if resource.ancestry
        attributes << child_class(resource)
        attributes.flatten.join(' ')
      end

      def shift_panel_by_depth(resource, multiplicator)
        multiplicator ||= 4

        shift   = multiplicator * resource.depth
        padding = multiplicator / 2
        margin  = shift - padding

        "padding-left: #{padding}em; " \
        "margin-left: #{margin}em; " \
        "#{'border-left: 2px solid gray' unless resource.root?}"
      end

      def random_bckgr_color(resource, no_color = false)
        return if no_color
        return if childless_child?(resource)
        color = random_color.join(', ')
        "background-color: rgba(#{color}, 0.7) !important"
      end

      private

      def childless_child?(resource)
        resource.is_childless? && resource.is_root? == false
      end

      def child_class(resource)
        childless_child?(resource) ? CLASSES[:child] : CLASSES[:parent]
      end

      def random_color(range = -50...50)
        sample_color.map do |light|
          light + Random.rand(range)
        end
      end

      def sample_color
        PRETTY_COLORS.values.sample
      end
    end
  end
end