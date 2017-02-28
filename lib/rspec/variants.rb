require "proc_to_ast"

module RSpec
  module Variants
    autoload :Tabular, "rspec/variants/tabular"

    module ExampleGroupMethods
      # This class is used to hold an instance of a condition by holding
      # each of the attributes specified for that condition.
      class Condition
        attr_reader :arg_names, :block

        def initialize(arg_names, &block)
          @arg_names = arg_names
          @block = block
        end
      end

      def data_condition(*args, &block)
        if args.size == 1 && args[0].instance_of?(Hash)
          params = args[0]
          first, *remaining = params.values

          set_conditions(params.keys) { first.product(*remaining) }
        else
          set_conditions(args, &block)
        end
      end

      def test_condition(*args, &block)
        opts = args.last.is_a?(Hash) ? args.pop : {}
        opts[:caller] = caller unless opts[:caller]
        args.push(opts)

        if @condition.nil?
          @conditions_pending_cases ||= []
          @conditions_pending_cases << [args, block]
        else
          define_cases(@condition, *args, &block)
        end
      end

      private

      def set_conditions(arg_names, &block)
        @condition = Condition.new(arg_names, &block)

        return unless @conditions_pending_cases
        @conditions_pending_cases.each do |e|
          define_cases(@condition, *e[0], &e[1])
        end
      end

      # This method is defining the effective equivalent of a test case
      # based on the conditions that it it able to determine as part of the
      # ExampleGroup.
      def define_cases(condition, *args, &block)
        # The first line is a bit tricky; it needs to be in place so that
        # `let` methods can be evaluated.
        instance = new

        if defined?(superclass::LetDefinitions)
          instance.extend superclass::LetDefinitions
        end

        # `extracted` can contain a simple list of conditions, such as
        # [[1, 2, 3], [5, 8, 13]]. But in the case of a tabular format,
        # it will contain an instance of RSpec::Variants::Table. The
        # call to `to_conditions` is what breaks the table down if
        # necessary. The end result is that `condition_sets` should
        # contain an array of data conditions.

        extracted = instance.instance_eval(&condition.block)

        condition_sets = extracted.is_a?(Array) ? extracted : extracted.to_conditions

        # This next assignment is needed in case there is only one
        # data condition specified.

        condition_sets = condition_sets.map { |x| Array[x] } unless condition_sets[0].is_a?(Array)

        condition_sets.each do |condition_set|
          pairs = [condition.arg_names, condition_set].transpose.to_h

          pretty_params = pairs.map do |name, val|
            "#{name}: #{conditions_inspect(val)}"
          end.join(", ")

          describe(pretty_params, *args) do
            pairs.each do |name, val|
              let(name) { val }
            end

            singleton_class.module_eval do
              define_method(:condition) do
                pairs
              end

              define_method(:all_conditions) do
                condition_sets
              end
            end

            module_eval(&block)
          end
        end
      end

      def conditions_inspect(obj)
        obj.is_a?(Proc) ? obj.to_raw_source : obj.inspect
      rescue Parser::SyntaxError
        return obj.inspect
      end
    end
  end

  module Core
    class ExampleGroup
      extend ::RSpec::Variants::ExampleGroupMethods
    end
  end
end
