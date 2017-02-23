module TcpsnitchAnalyzer 
  class TraceParser
    def initialize(opts, files)
      @opts = opts
      @files = files
    end

    def parse_json_object(line)
      Oj.load(line.chomp("\n"))
    rescue => e
      TcpsnitchAnalyzer.error(e)
    end

    def pass_filter?(hash)
      @opts.event_filter ? hash[:type].eql?(@opts.event_filter) : true
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

    def build_data_point(hash)
      raise unless val = node_val(hash, @opts.node_path)
      timestamp = node_val(hash, 'timestamp')
      TcpsnitchAnalyzer::DataPoint.new(val, timestamp)
    rescue
      TcpsnitchAnalyzer.error("invalid -n argument: '#{@opts.node_path}'")
    end
  
    def process_file(file)
      File.open(file).lazy.map do |line|
        parse_json_object(line)
      end.select do |hash|
        pass_filter?(hash)  
      end.map do |hash|
        build_data_point(hash)  
      end
    end

    def values
      @files.lazy.flat_map do |file|
        process_file(file)
      end
    end
  end
end
