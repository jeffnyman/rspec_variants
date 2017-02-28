require "binding_of_caller"
require "rspec/variants/table"

module RSpec
  module Variants
    module TabularSyntax
      def |(other)
        # The first two statements are used to get the data_condition block
        # binding as well as the caller instance. The caller instance will be
        # an instance of ExampleGroup.
        data_condition_binding = binding.of_caller(1)
        caller_instance = eval('self', data_condition_binding)

        if caller_instance.instance_variable_defined?(:@__condition_table)
          table = caller_instance.instance_variable_get(:@__condition_table)
        else
          table = RSpec::Variants::Table.new
          caller_instance.instance_variable_set(:@__condition_table, table)
        end

        row = Table::Row.new(self)
        table.add_row(row)
        row.add_condition(other)
        table
      end
    end

    module Tabular
      refine Object do
        include TabularSyntax
      end

      if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create("2.4.0")
        refine Integer do
          include TabularSyntax
        end
      else
        # rubocop:disable Lint/UnifiedInteger
        refine Fixnum do
          include TabularSyntax
        end

        refine Bignum do
          include TabularSyntax
        end
      end

      refine Array do
        include TabularSyntax
      end

      refine NilClass do
        include TabularSyntax
      end

      refine TrueClass do
        include TabularSyntax
      end

      refine FalseClass do
        include TabularSyntax
      end
    end
  end
end
