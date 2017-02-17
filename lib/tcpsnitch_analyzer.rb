require 'oj'
require 'tcpsnitch_analyzer/opt_parser'
require 'tcpsnitch_analyzer/trace_parser'
require 'tcpsnitch_analyzer/stat'
require 'tcpsnitch_analyzer/descriptive_stat'
require 'tcpsnitch_analyzer/proportion_stat'
require 'tcpsnitch_analyzer/time_serie_stat'

module TcpsnitchAnalyzer
  EXECUTABLE = 'tcpsnitch_analyzer'.freeze
  VERSION = '0.0.1'.freeze
  
  # Configure Oj
  Oj.default_options = { symbol_keys: true }
  
  class << self
    def error(msg)
      puts "#{EXECUTABLE}: #{msg}."
      puts "Try '#{EXECUTABLE} -h' for more information."
      exit 1
    end
  end # class << self

  class DataPoint
    attr_accessor :val, :timestamp
  
    def initialize(val, timestamp_hash)
      @val = val
      @timestamp = usec_from_ts(timestamp_hash)
    end

    def usec_from_ts(ts)
        ts[:sec] * 1000000 + ts[:usec]
    end
  end
end # module
