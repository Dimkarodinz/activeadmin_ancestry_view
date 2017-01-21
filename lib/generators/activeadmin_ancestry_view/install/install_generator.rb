module ActiveadminAncestryView
  class Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        target_file_path = 'app/assets/javascripts/active_admin'
        ref = "#= require active_admin/base\n"
        begin
          inject_into_file("#{target_file_path}.coffee", js_to_add, after: ref)
        rescue Errno::ENOENT
          inject_into_file("#{target_file_path}.js.coffee", js_to_add, after: ref)
        end
      end

      def add_stylesheets
        target_file_path = 'app/assets/stylesheets/active_admin'
        begin
          prepend_file("#{target_file_path}.scss", css_to_add)
        rescue Errno::ENOENT
          prepend_file("#{target_file_path}.css.scss", css_to_add)
        end
      end

      private

      def js_to_add
        "#= require activeadmin_ancestry_view/base\n"
      end

      def css_to_add
        "@import \"activeadmin_ancestry_view/base\";\n"
      end
    end
  end
end