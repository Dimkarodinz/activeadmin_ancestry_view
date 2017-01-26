module ActiveadminAncestryView
  module ResourceDSL
    class ShowGenerator < ActionGenerator
      def call(opt = {}, &block)
        "show do\n" \
          "#{block.call if block_given?}\n" \
          "sorted = resource.subtree.sort_by(&:full_ancestry)\n" \
          "sorted.each do |res|\n" \
            "render partial: '#{template_path}', " \
              "locals: { resource: res, " \
                       "headers: #{opt[:headers] || '{ title: :id }'}, " \
                       "table: #{opt[:table] || '{}' } }\n" \
          "end\n" \
        "end"
      end
    end
  end
end