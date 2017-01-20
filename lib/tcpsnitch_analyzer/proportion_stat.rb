module TcpsnitchAnalyzer
  class ProportionStat
    @@count = 0
    @@hash = Hash.new(0)

    def self.add_data_point(val, timestamp)
      @@count += 1
      @@hash[val] += 1
    end

    def self.print(options)
      @@hash.sort_by { |val, count| -count }.each do |val, count|
        pc = ((count.to_f/@@count) * 100).round(2)
        puts "#{pc}%".ljust(7) + "(#{count})".ljust(10) + "#{val}"
      end
      puts "100%".ljust(7) + "(#{@@count})" 
    end

  end # class
end # module
