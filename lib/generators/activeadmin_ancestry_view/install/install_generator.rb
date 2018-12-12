module ActiveadminAncestryView
  class Generators
    class InstallGenerator < Rails::Generators::Base
      def add_javascripts
        target_file_path = 'app/assets/javascripts/active_admin'
        ref = "#= require active_admin/base\n"
        vanilla_ref = "//= require active_admin/base\n"
        begin
          inject_into_file("#{target_file_path}.coffee", js_to_add, after: ref)
        rescue
          begin
            inject_into_file("#{target_file_path}.js.coffee", js_to_add, after: ref)
          rescue
            inject_into_file("#{target_file_path}.js", vanilla_js_to_add, after: vanilla_ref)
          end
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

      def add_concerns
        ref = 'has_ancestry'
        Dir['app/models/**/*.rb'].each do |model_file|
          if File.readlines(model_file).grep(/has_ancestry/).any?
            inject_into_file(model_file, concern_to_add, before: ref)
          end
        end
      end

      private

      def concern_to_add
        "include Concerns::ActiveadminAncestryView::ModelMethods\n\t"
      end

      def js_to_add
        "#= require activeadmin_ancestry_view/base\n"
      end

      def vanilla_js_to_add
        "//= require activeadmin_ancestry_view/vanilla-base\n"
      end

      def css_to_add
        "@import \"activeadmin_ancestry_view/base\";\n"
      end
    end
  end
end