# frozen_string_literal: true

require "maxmind/geoip2"

module Tornados
  class GeoEnrich < Service
    private

    attr_reader :ip_list, :reader
    
    public

    def initialize(ip_list, max_db_file_path)
        @ip_list = ip_list
        @reader = MaxMind::GeoIP2::Reader.new(database: max_db_file_path)
    end
    
    private

    def execute
        ip_list.map do |arr|
           [arr.first, *country_code_by_ip(arr.first)]
        end
    end
    
    def country_code_by_ip(ip)
         record = reader.country(ip)
         [record.country.iso_code, record.country.name]
    end
  end
end