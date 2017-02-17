module TcpsnitchAnalyzer
  class ProportionStat < Stat
    def initialize(opts, datapoints)
      super
      @hash = Hash.new(0)
      @total_count = 0
    end

    def sort_by_val
      @datapoints.each do |datapoint|
        @total_count += 1
        @hash[datapoint.val] += 1
      end
    end

    def compute
      super
      sort_by_val
      @hash.sort_by { |val, count| -count }.each do |val, count|
        pc = ((count.to_f/@total_count) * 100).round(2)
        puts "#{pc}%".ljust(7) + "(#{count})".ljust(10) + "#{val}"
      end
      puts "100%".ljust(7) + "(#{@total_count})" 
    end

  end # class
end # module
