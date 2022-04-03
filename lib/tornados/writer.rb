# frozen_string_literal: true

module Tornados
  class Writer < Service
    private

    def execute
      write
    end

    def write
      raise NotImplementedError
    end
  end
end
