module ActiveadminAncestryView
  module ResourceDSL
    class ActionBuilder
      attr_reader :action_generator, :opt, :block

      def initialize(action_generator, opt = {}, &block)
        @opt = opt
        @action_generator = action_generator
        @block = block if block_given?
      end

      def call
        action_generator.call(opt, &block)
      end
    end
  end
end