# frozen_string_literal: true

module Tornados
  class Errors < StandardError; end
  class ResponseError < Errors; end
  class MaxDbKeyNotFoundError < Errors; end
  class ZipFileToLargeError < Errors; end
end
