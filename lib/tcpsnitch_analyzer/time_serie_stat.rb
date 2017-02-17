module TcpsnitchAnalyzer
  class TimeSerieStat < Stat
    @x = []
    @y = []

    def compute
      super
      return unless @opts.should_plot
      @datapoint.each do |dp|
        @@min ||= dp.timestamp
        @@x.push(dp.timestamp-@@min)
        @@y.push(dp.val)
      end
      print
    end

    def print
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.title  "Time serie: #{options.node_path}(t)"
          plot.xlabel "Micro seconds"
          plot.ylabel @opts.node_path.split('.').last.capitalize
        
          plot.data << Gnuplot::DataSet.new([@x,@y]) do |ds|
            ds.with = "lines"
            ds.linewidth = 4
            ds.notitle
          end
        end
      end # Gnuplot.open
    end # def self.print

  end # class
end # module
