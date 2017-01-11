require 'oj'

require 'tcpsnitch_analyzer/opt_parser'
require 'tcpsnitch_analyzer/descriptive_stat'
require 'tcpsnitch_analyzer/proportion_stat'
require 'tcpsnitch_analyzer/time_serie_stat'

module TcpsnitchAnalyzer
  EXECUTABLE = 'tcpsnitch_analyzer'
  VERSION = '0.0.1'
  
  # Configure Oj
  Oj.default_options = { symbol_keys: true }

  class << self
    def process_files(options, files)
      # We DO NOT want to read the entire JSON files into memory.
      # We DO NOT want to build a Ruby object for the entire JSON array.
      #
      # Instead, we want to the file line by line, where each line consists of 
      # a single event. We then instantiate each event individually and discard 
      # them as we consume the file, thus giving O(1) memory consumption.
      matched_data = false

      files.each do |file|
        # IO.each should not read entire file in memory. To verify?
        File.open(file).each_with_index do |line, index|
          next if index == 0    # First line is opening '[' of JSON Array
          next if line.eql? "]" # Last line is closing ']' of JSON Array

          # Parse JSON object
          begin 
            hash = Oj.load(line.chomp(",\n")) # Remove ',\n' after JSON object
          rescue Exception => e 
            error(e)
          end
         
          # Skip if filter does not match
          next unless filter(hash, options.event_filter)  
          matched_data = true
          
          # Extract value
          begin
            val = node_val(hash, options.node_path)
          rescue Exception => e
            error("invalid -n argument: '#{options.node_path}'")
          end

          # Compute on value
          if options.analysis_type == TimeSerieStat
            options.analysis_type.add_point(node_val(hash, 'timestamp'), val)
          else
            options.analysis_type.add_val(val)
          end
        end
      end

      # Output results
      puts_options_header(options)
      if matched_data 
        options.analysis_type.print(options)
      else
        puts "No data point matching criterias."
      end
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
