# frozen_string_literal: true

require "tempfile"
require "rubygems/package"
require "zlib"

module Tornados
  # Service to download geoip database file from maxmind.com:
  # https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=YOUR_LICENSE_KEY&suffix=tar.gz
  class MaxDbFetcher < Service
    GEO_API_DATABASE_URI = "https://download.maxmind.com/app/geoip_download"
    GEO_API_DATABASE_PATH = "/app/geoip_download"
    REQUEST_OPTION = {
      edition_id: "GeoLite2-Country",
      suffix: "tar.gz"
    }.freeze
    MAX_DB_FILE_NAME ="GeoLite2-Country.mmdb"
    # GZ_FILE_NAME = "max_db.tar.gz"
    MAX_DB_STORAGE = "./"
    # MAX_SIZE = (1024**2) * 200 # 200 MB

    private

    attr_accessor :key, :max_db_file_path

    public

    def initialize(key, max_db_storage = nil)
      @key = key
      max_db_storage = max_db_storage || MAX_DB_STORAGE
      @max_db_file_path = File.join(max_db_storage, MAX_DB_FILE_NAME)
    end

    private

    def execute
      extract_tar_gz_file(StringIO.new(body))
      max_db_file_path
    end

    def body
      HttpClient.call(
        GEO_API_DATABASE_URI,
        GEO_API_DATABASE_PATH,
        :get,
        license_key_option.merge(REQUEST_OPTION)
      ).body
    end

    def license_key_option
      raise MaxDbKeyNotFoundError unless key

      {license_key: key}
    end

    def extract_tar_gz_file(file)
      Zlib::GzipReader.wrap(file) do |gz|
        Gem::Package::TarReader.new(gz) do |tar|
          tar.each { |entry| save_max_db_file(entry.read) if entry.full_name.include?(MAX_DB_FILE_NAME) }
        end
      end
    end
    
    def save_max_db_file(file)
      File.write(max_db_file_path, file, mode: "wb")
    end
  end
end
