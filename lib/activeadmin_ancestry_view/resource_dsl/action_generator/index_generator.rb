module ActiveadminAncestryView
  module ResourceDSL
    class IndexGenerator < ActionGenerator

      def build(opt = {}, &block)
        "index as: :block do |res|\n " \
          "#{block.call if block_given?}\n" \
          "render partial: 'activeadmin_ancestry_view/main', locals: { resource: res }\n" \
        "end"
      end
    end
  end
end