# frozen_string_literal: true

require 'csv'

module Tornados
  class CsvFormater < Formater
    private

    def format
      data.map(&:to_csv).join
    end
  end
end
