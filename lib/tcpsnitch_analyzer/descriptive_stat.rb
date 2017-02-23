require 'descriptive_statistics'
require 'gnuplot'

module TcpsnitchAnalyzer
  class DescriptiveStat < Stat
    def initialize(opts, files)
      super
      validate_data_type!(@datapoints.first.val)
    end

    def validate_data_type!(val)
      invalid_val!(val) if !val.is_a?(Integer) 
    end
 
    def invalid_val!(val)
      if val.is_a? Hash
        TcpsnitchAnalyzer.error("invalid value for descriptive statistic: "\
                                  "non-terminal node")
      else
        TcpsnitchAnalyzer.error("invalid value type for descriptive statistic:"\
                                " '#{val}'")
      end
    end

    def cdf(sorted_val)
      n = sorted_val.size
      sorted_val.map do |el|
        ((sorted_val.rindex { |v| v <= el } || -1.0) + 1.0) / n * 100.0
      end
    end

    def plot(vals) # Plot a CDF
      x = vals.sort
      y = cdf(x)

      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          if vals.min < 0 or vals.max < 0
            plot.xrange "[#{vals.min}:#{vals.max}]"
          else
            plot.xrange "[#{vals.min}:#{vals.max}]; set logscale x"
          end
          plot.title  "CDF for #{@opts.node_path} (#{@opts.event_filter} events)"
          plot.xlabel "Value"
          plot.ylabel "Normal CDF"
          plot.data << Gnuplot::DataSet.new([x,y]) do |ds|
            ds.with = "lines"
            ds.linewidth = 4
            ds.title = @opts.node_path.split('.').last
          end
        end
      end # Gnuplot.open
    end

    def compute
      super
      vals = @datapoints.map(&:val).to_a
      vals.descriptive_statistics.each do |key, value|
        puts "#{key}".ljust(20) + "#{value}" 
      end
      plot(vals) if @opts.should_plot && vals.range > 0 
    end 

  end # class
end # module

