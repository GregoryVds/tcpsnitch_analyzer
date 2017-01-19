require 'oj'

require 'tcpsnitch_analyzer/opt_parser'
require 'tcpsnitch_analyzer/descriptive_stat'
require 'tcpsnitch_analyzer/proportion_stat'
require 'tcpsnitch_analyzer/time_serie_stat'

module TcpsnitchAnalyzer
  EXECUTABLE = 'tcpsnitch_analyzer'.freeze
  VERSION = '0.0.1'.freeze
  
  # Configure Oj
  Oj.default_options = { symbol_keys: true }

  class << self
    def parse_json_object(line)
      return Oj.load(line.chomp(",\n")) # Remove ',\n' after JSON object
    rescue => e
      error(e)
    end

    def extract_val(hash, node_path)
      return node_val(hash, node_path)
    rescue
      error("invalid -n argument: '#{node_path}'")
    end

    def compute_val(analysis_type, val, timestamp)
      if analysis_type == TimeSerieStat
        analysis_type.add_point(node_val(timestamp, val))
      else
        options.analysis_type.add_val(val)
      end
    end

    def output_results(options, values_count)
      puts_options_header(options)
      if values_count > 0
        options.analysis_type.print(options)
      else
        puts "No data point matching criterias."
      end
    end
    
    def process_files(options, files)
      # We DO NOT want to read the entire JSON files into memory.
      # We DO NOT want to build a Ruby object for the entire JSON array.
      #
      # Instead, we want to the file line by line, where each line consists of 
      # a single event. We then instantiate each event individually and discard 
      # them as we consume the file, thus giving O(1) memory consumption.
      values_count = 0

      files.each do |file|
        # IO.each should not read entire file in memory. To verify?
        File.open(file).each_with_index do |line, index|
#          next if (line.eql? "[" or line.eql? "]") 
          hash = parse_json_object(line)

          next unless filter(hash, options.event_filter)  # Skip by filter?
          values_count += 1

          val = extract_val(hash, options.node_path)
          timestamp = node_val(hash, 'timestamp')

          compute_val(options.analysis_type, val, timestamp) 
        end
      end

      output_results(options, values_count)
    end
    
    def error(msg)
      puts "#{EXECUTABLE}: #{msg}."
      puts "Try '#{EXECUTABLE} -h' for more information."
      exit 1
    end

    def filter(hash, filter)
      if filter then
        hash[:type] == filter ? hash : nil
      else
        hash
      end
    end

    def val_for(hash, keys)
        keys.reduce(hash) { |h, key| h[key] }
    end

    def keys_from_path(path)
      path.split('.').collect(&:to_sym)
    end

    def node_val(hash, path)
      val_for(hash, keys_from_path(path))
    end

    def puts_options_header(options)
      puts "JSON node:".ljust(15) + "#{options.node_path}"
      event_filter = options.event_filter ? options.event_filter : "/" 
      puts "Type filter:".ljust(15) + event_filter
      puts ""
    end

  end # class << self
end # module
