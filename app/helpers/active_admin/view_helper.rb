module ActiveAdmin
  module ViewHelper
    CLASSES = { child:  'panel-childless',
                parent: 'panel-parent' }

    PRETTY_COLORS = { red:    [255, 102, 102], yellow: [255, 178, 102],
                      green:  [102, 255, 102], blue:   [102, 178, 255], 
                      violet: [178, 102, 255], gray:   [192, 192, 192] }

    def generate_panel_classes(user)
      attributes = []
      attributes << user.path_ids if user.ancestry
      attributes << child_class(user)
      attributes.flatten.join(' ')
    end

    def shift_panel_by_depth(user, multiplicator = 2)
      "margin-left: #{user.depth * multiplicator}em"
    end

    def random_bckgr_color(user)
      return if childless_child?(user)
      color = random_color.join(', ')
      "background-color: rgba(#{color}, 0.7) !important"
    end

    private

    def childless_child?(user)
      user.is_childless? && user.is_root? == false
    end

    def child_class(user)
      childless_child?(user) ? CLASSES[:child] : CLASSES[:parent]
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