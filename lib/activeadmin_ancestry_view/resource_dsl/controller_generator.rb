module ActiveadminAncestryView
  module ResourceDSL
    class ControllerGenerator
      def initialize(controller_builder)
        @controller_builder = controller_builder
      end

      def call
        @controller_builder.call
      end
    end
  end
end