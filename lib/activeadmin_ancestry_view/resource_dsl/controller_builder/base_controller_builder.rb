module ActiveadminAncestryView
  module ResourceDSL
    class ControllerBuilder
      class Base
        def call
          %{controller do
              private
              #{build_attr_accessor}
              #{build_before_action}
              #{build_after_action}
            end}
        end

        private

        def build_attr_accessor
        end

        def build_before_action
        end

        def build_after_action
        end
      end
    end
  end
end
