# frozen_string_literal: true

module Tornados
  class Filter
      private

      attr_reader :condition

      public

    def initialize(lambda)
      @condition = lambda
    end
    
    def accept?(checked_value)
      condition.call(checked_value)
    end
  end
end