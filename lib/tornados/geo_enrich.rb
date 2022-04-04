# frozen_string_literal: true

require "maxmind/geoip2"

module Tornados
  class GeoEnrich < Service
    private

    attr_reader :ip_list, :filter, :reader
    
    public

    def initialize(ip_list, max_db_file_path, filter = nil)
      @filter = filter
      @ip_list = ip_list
      @reader = MaxMind::GeoIP2::Reader.new(database: max_db_file_path)
    end
    
    private

    def execute
      ip_list.each_with_object([]) do |arr, result|
        ip = arr.first
        iso_code, name = *country_code_by_ip(ip)
        if filter
          result << [ip, iso_code, name] if filter.accept?(iso_code)
        else
          result << [ip, iso_code, name]
        end
      end
    end
    
    def country_code_by_ip(ip)
      record = reader.country(ip)
      [record.country.iso_code, record.country.name]
    end
  end
end