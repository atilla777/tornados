# frozen_string_literal: true

module Tornados
  TOR_NODES_LIST_URI = "https://raw.githubusercontent.com"
  TOR_NODES_LIST_PATH = "SecOps-Institute/Tor-IP-Addresses/master/tor-exit-nodes.lst"

  # Service for download exit tor nodes IP list.
  # Result is array of arrays:
  # [["ip addres 1"], ["ip addres 2"], ... ["ip addres N"]]
  class NodesFetcher < Service
    private

    attr_reader :uri, :path

    public

    def initialize(uri = nil)
      @uri = uri || URI(TOR_NODES_LIST_URI)
      @path = TOR_NODES_LIST_PATH
    end
    
    def self.default_url
      [TOR_NODES_LIST_URI, TOR_NODES_LIST_PATH].join("/")
    end

    private

    def execute
      response.body.split("\n").map { |string| [string] }
    end

    def response
      HttpClient.call(uri, path, :get, {})
    end
  end
end
