module ActiveadminAncestryView
  module ResourceDSL
    class IndexGenerator < ActionGenerator
      def call(opt = {}, &block)
        "index as: :block do |res|\n " \
          "#{block.call if block_given?}\n" \
          "render partial: '#{template_path}', " \
            "locals: { resource: res, " \
                       "headers: #{opt[:headers] || '{ title: :id }'}, " \
                       "table: #{opt[:table] || '{}' } }\n" \
        "end"
      end
    end
  end
end