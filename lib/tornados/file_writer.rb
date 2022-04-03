# frozen_string_literal: true

module Tornados
  class FileWriter < Writer
    private

    attr_reader :result_file

    public

    RESULT_FILE = "tor_exit_nodes_list.csv"

    def initialize(data, file = nil)
      super(data)
      @result_file = file || RESULT_FILE
    end
    
    def self.default_result_file
     RESULT_FILE
    end

    private

    def write
      File.write(result_file, data)
    end
  end
end
