module ActiveadminAncestryView
  module ResourceDSL
    class ShowActionBuilder < ActionBuilder
      def call(opt = {}, &block)
        %{show do
          #{block.call if block_given?}
          sorted = resource.subtree.sort_by(&:full_ancestry)
          sorted.each do |res|
            render partial: '#{template_path}', 
              locals: { resource: res, 
                       headers: #{opt[:headers] || '{ title: :id }'}, 
                       table: #{opt[:table] || '{}' } }
          end
        end}
      end
    end
  end
end