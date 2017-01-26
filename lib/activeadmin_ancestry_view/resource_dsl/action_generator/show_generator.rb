module ActiveadminAncestryView
  module ResourceDSL
    class ShowGenerator < ActionGenerator

      def build(opt = {}, &block)
        "show do\n" \
          "#{block.call if block_given?}\n" \
          "sorted = resource.subtree.sort_by(&:full_ancestry)\n" \
          "sorted.each do |res|\n" \
            "render partial: 'activeadmin_ancestry_view/main', locals: { resource: res }\n" \
          "end\n" \
        "end"
      end
    end
  end
end