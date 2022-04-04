# frozen_string_literal: true

require "optparse"

module Tornados
  class CliClient
    private

    attr_reader :options
    
    public
    
    def start
      prepare_options
      print_prompt
      prepare_result
      print_finish_message
    end

    private

    def print_prompt()
      puts <<~TEXT
        Runs with args:
        tor nodes URI = #{options[:nodes_list] || Tornados::NodesFetcher.default_url}
        result_file = #{options[:result_file] || Tornados::FileWriter.default_result_file}
      TEXT
    end

    def print_finish_message
      puts "Work done. See result in #{Tornados::FileWriter.default_result_file}. Bye!"
    end

    def prepare_result
      tor_exit_nodes = Tornados::NodesFetcher.call(options[:exit_nodes_uri])
      geobase_file_path = Tornados::MaxDbFetcher.call(options[:max_mind_key] || ENV["GEO_API_DATABASE_LICENSE_KEY"])
      enriched_tor_exit_nodes = Tornados::GeoEnrich.call(tor_exit_nodes, geobase_file_path, filter)
      csv_enriched_tor_exit_nodes = Tornados::CsvFormater.call(enriched_tor_exit_nodes)
      Tornados::FileWriter.call(csv_enriched_tor_exit_nodes, options[:result_file])
    end
    
    def filter
      return nil unless options[:included_iso_codes]

      l = -> (checked_value) { options[:included_iso_codes].include?(checked_value) }
      Tornados::Filter.new(l) 
    end

    def prepare_options
      @options = {}
      optparse = OptionParser.new do |opts|
        opts.banner = usage_example_message

        opts.on( '-h', '--help', 'Display this screen' ) do
          puts opts
          exit
        end

        opts.on("-u", "--uri <URI>", "Uri with tor exit nodes list") do |v|
          @options[:exit_nodes_uri] = v
        end

        opts.on("-f", "--file <file>", "Result file with path") do |v|
          @options[:result_file] = v
        end

        opts.on("-k", "--key <file>", "MaxMind API key") do |v|
          puts 111
          puts ENV["GEO_API_DATABASE_LICENSE_KEY"]
          @options[:max_mind_key] = v
        end

        opts.on("-i", "--include <ISO code1, ISO codeN>", "Include only ip with this iso codes") do |v|
          @options[:included_iso_codes] = v.split(",").map(&:strip)
        end
      end

      optparse.parse!
    end
    
    def usage_example_message
      "GEO_API_KEY=key tornado -u <exit nodes uri> -f <result file> -i <ip country iso codes>"
    end
  end
end
