module ActiveadminAncestryView
  module ResourceDSL
    class IndexActionBuilder < ActionBuilder
      def call(opt = {}, &block)
        %{index as: :block do |res| 
            #{block.call if block_given?}
            #{render_partial_with_options(opt)}
          end}
      end
    end
  end
end