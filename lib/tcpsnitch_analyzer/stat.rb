module TcpsnitchAnalyzer
  class Stat
    def initialize(opts, datapoints)
      @opts = opts
      @datapoints = datapoints
    end

    def compute
      output_header
    end

    def output_header
      event_filter = @opts.event_filter ? @opts.event_filter : '/'
      puts 'Filter:'.ljust(15) + event_filter
      puts 'Node:'.ljust(15) + @opts.node_path
      # puts 'Data points:'.ljust(15) + @data_count.to_s
      puts 'Analysis:'.ljust(15) + self.class.name.split('::').last
      puts ''
    end
  end
end
