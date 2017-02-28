module RSpec
  module Variants
    class Table
      attr_reader :last_row

      def initialize
        @rows = []
        @last_row = nil
      end

      def add_row(row)
        unless @rows.find { |r| r.object_id == row.object_id }
          @rows << row
          @last_row = row
        end
        self
      end

      def add_condition_to_last_row(condition)
        last_row.add_condition(condition)
        self
      end

      alias | add_condition_to_last_row

      def to_a
        @rows.map(&:to_a)
      end

      alias to_conditions to_a

      class Row
        def initialize(condition)
          @conditions = [condition]
        end

        def add_condition(condition)
          @conditions << condition
        end

        def to_a
          @conditions
        end

        def to_conditions
          [@conditions]
        end
      end
    end
  end
end
