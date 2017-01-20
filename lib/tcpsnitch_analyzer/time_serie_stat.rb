module TcpsnitchAnalyzer
  class TimeSerieStat
    @@x = []
    @@y = []

    def self.add_data_point(val, timestamp)
      usec = timestamp[:sec] * 1000000 + timestamp[:usec]
      @@min ||= usec
      @@x.push(usec-@@min)
      @@y.push(val)
    end

    def self.print(options)
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.title  "Time serie: #{options.node_path}(t)"
          plot.xlabel "Micro seconds"
          plot.ylabel options.node_path.split('.').last.capitalize
        
          plot.data << Gnuplot::DataSet.new([@@x,@@y]) do |ds|
            ds.with = "lines"
            ds.linewidth = 4
            ds.notitle
          end
        end
      end # Gnuplot.open
    end # def self.print

  end # class
end # module
