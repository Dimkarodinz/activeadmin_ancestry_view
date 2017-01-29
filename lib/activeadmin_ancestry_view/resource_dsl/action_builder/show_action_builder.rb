module ActiveadminAncestryView
  module ResourceDSL
    class ShowActionBuilder < ActionBuilder
      def call(opt = {}, &block)
        %{show do
          #{block.call if block_given?}
          sorted_subtree = resource.subtree.sort_by(&:full_ancestry)
          sorted_subtree.each do |res|
            #{render_partial_with_options(opt)}
          end
        end}
      end
    end
  end
end