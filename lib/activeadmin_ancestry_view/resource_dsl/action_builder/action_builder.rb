module ActiveadminAncestryView
  module ResourceDSL
    class ActionBuilder
      DEFAULT_OPTIONS = {
        headers: '{ title: :id }',
        table: '{}',
        no_color: 'false',
        no_childless_link: 'false',
        shift: '4'
      }

      def call(opt = {}, &block)
      end

      private

      def render_partial_with_options(opt)
        %{render partial: '#{template_path}', 
            locals: {
              resource: res,
              headers: #{opt[:headers] || DEFAULT_OPTIONS[:headers]}, 
              table: #{opt[:table] || DEFAULT_OPTIONS[:table] },
              no_color: #{opt[:no_color] || DEFAULT_OPTIONS[:no_color] },
              no_childless_link: #{opt[:no_childless_link] || DEFAULT_OPTIONS[:no_childless_link]},
              shift_depth: #{opt[:shift_depth] || DEFAULT_OPTIONS[:shift] }
            }
          }
      end

      def template_path
        'activeadmin_ancestry_view/main'
      end
    end
  end
end