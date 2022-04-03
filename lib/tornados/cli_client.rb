# frozen_string_literal: true

module Tornados
  class CliClient
    def start
      user_args = args
      if user_args.empty?
        print_prompt
      else
        print_prompt_with_input
      end
      prepare_result(user_args)
      print_finish_message
    end

    private

    def print_prompt
      puts <<~TEXT
        Example of usage:
        GEO_API_KEY=key tornado <uri>, <result file>
        Runs with default args:
        tor nodes URI = #{Tornados::NodesFetcher.default_url}
        result_file = #{Tornados::FileWriter.default_result_file}
      TEXT
    end

    def print_prompt_with_input
      puts <<~TEXT
        Example of usage:
        GEO_API_KEY=key tornado <uri>, <result file>
        Runs with args:
        tor nodes URI = #{args[:uri]}
        result_file = #{args[:file]}
      TEXT
    end

    def print_finish_message
      puts "Work done. See result in #{Tornados::FileWriter.default_result_file}. Bye!"
    end

    def args
      result = ARGV
      return {} if result.empty?
      {uri: result.first, file: result.last}
    end

    def prepare_result(args)
      tor_exit_nodes = Tornados::NodesFetcher.call(args[:uri])
      geobase_file_path = Tornados::MaxDbFetcher.call
      enriched_tor_exit_nodes = Tornados::GeoEnrich.call(tor_exit_nodes, geobase_file_path)
      csv_enriched_tor_exit_nodes = Tornados::CsvFormater.call(enriched_tor_exit_nodes)
      Tornados::FileWriter.call(csv_enriched_tor_exit_nodes, args[:file])
    end
  end
end
