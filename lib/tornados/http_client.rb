# frozen_string_literal: true

require "faraday"
require "faraday/net_http"

module Tornados
  class HttpClient
    attr_reader :connection, :url, :path, :method, :params, :logger_status

    def initialize(url, path, method, params, logger_status: false)
      @url = url
      @path = path
      @method = method
      @params = params
      @connection = prepare_connection
      @logger_status = logger_status
    end

    def self.call(*args)
      new(*args).send(:execute)
    end

    private
    
    def prepare_connection
      Faraday.new(url: url, params: {}, headers: {}) do |f|
        f.use Faraday::Response::Logger if logger_status
        f.use Faraday::Response::RaiseError
      end
    end

    def execute
      connection.public_send(method, path) do |req|
        req.params = params
        req.body if method == :post
      end
    rescue Faraday::Error => e
      raise ResponseError.new(e)
    end
  end
end
