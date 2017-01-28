module ActiveadminAncestryView
  module ResourceDSL
    class ActionGenerator
      def initialize(action_builder, opt = {}, &block)
        @opt = opt
        @action_builder = action_builder
        @block = block if block_given?
      end

      def call
        action_builder.call(opt, &block)
      end

      private

      attr_reader :action_builder, :opt, :block
    end
  end
end