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

    def output_header(options, data_points)
      event_filter = options.event_filter ? options.event_filter : "/" 
      puts "Filter:".ljust(15) + event_filter
      puts "Node:".ljust(15) + options.node_path
      puts "Data points:".ljust(15) + data_points.to_s 
      puts "Analysis:".ljust(15) + options.analysis_type.name.split('::').last
      puts ""
    end

    def skip_line?(line)
      /(\[|\])\s*/.match(line) # Opening/Closing of main array
    end

    def output_results(options, data_points)
      output_header(options, data_points)
      if data_points > 0
        options.analysis_type.print(options)
      else
        puts "No data point matching criterias."
      end
    end

    # We DO NOT want to read the entire JSON files into memory.
    # We DO NOT want to build a Ruby object for the entire JSON array.
    # Instead, we want to the file line by line, where each line consists of 
    # a single event. We then instantiate each event individually and discard 
    # them as we consume the file, thus giving O(1) memory consumption.
    def process_files(opt, files)
      data_points = 0
      files.each do |file|
        File.open(file).each_with_index do |line, index|
          next if skip_line? line
          next unless hash = filter(parse_json_object(line), opt.event_filter)
          data_points += 1
          ts = node_val(hash, 'timestamp')
          opt.analysis_type.add_data_point(extract_val(hash, opt.node_path), ts)
        end
      end
      output_results(opt, data_points)
      data_points
    end
    
  end # class << self
end # module
