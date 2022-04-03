# frozen_string_literal: true

module Tornados
  class Service
    private

    attr_reader :data

    public

    def initialize(data)
      @data = data
    end

    def self.call(*args, &block)
      new(*args, &block).send(:execute)
    end

    def execute
      raise NotImplementedError
    end
  end
end
