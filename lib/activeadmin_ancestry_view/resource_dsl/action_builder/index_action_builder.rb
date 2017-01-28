module ActiveadminAncestryView
  module ResourceDSL
    class IndexActionBuilder < ActionBuilder
      def call(opt = {}, &block)
        %{index as: :block do |res| 
            #{block.call if block_given?}
            render partial: '#{template_path}', 
              locals: {
                resource: res, 
                headers: #{opt[:headers] || '{ title: :id }'}, 
                table: #{opt[:table] || '{}' }
              }
          end}
      end
    end
  end
end