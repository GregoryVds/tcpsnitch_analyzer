require 'optparse'
require 'ostruct'

module TcpsnitchAnalyzer
  class OptParser 
    def self.default_options
      o = OpenStruct.new
      o.should_plot = true
      o.analysis_type = ProportionStat
      o.event_filter = nil 
      o.node_path = "type"
      o
    end

    def self.parse(args)
      options = default_options

      begin
        OptionParser.new do |opts|
          opts.banner = "Usage: #{EXECUTABLE} [-h] [options] file...\n"
          opts.separator ""
          opts.separator "Analyze tcpsnitch JSON traces."
          opts.separator ""
          opts.separator "Options:"
          
          opts.on("-a", "--analysis [TYPE]", "TYPE of statistic analysis: 
                  descriptive (d), proportion (p) or timeserie (t).") do |type|
            TcpsnitchAnalyzer.error("missing -a argument") unless type 

            case type.downcase
            when /^d.*/
              options.analysis_type = DescriptiveStat
            when /^p.*/
              options.analysis_type = ProportionStat
            when /^t.*/
              options.analysis_type = TimeSerieStat
            else
              TcpsnitchAnalyzer.error("invalid -a argument: '#{type}'")
            end
          end
   
          opts.on("-e", "--event [FILTER]", "filter on events of type FILTER") do |ev|
            TcpsnitchAnalyzer.error("missing -e argument") unless ev 
            options.event_filter = ev          
          end

          opts.on_tail("-h", "--help", "show this help text") do 
            puts opts
            exit
          end
   
          opts.on("-n", "--node [PATH]", "compute on node at PATH") do |node| 
            TcpsnitchAnalyzer.error("missing -n argument") unless node 
            options.node_path = node 
          end
   
          opts.on_tail("--version", "show version") do 
            puts VERSION
            exit
          end

        end.parse!(args) # OptionParser
      rescue OptionParser::ParseError => e 
        TcpsnitchAnalyzer.error(e)
      end

      options
    end # def self.parse

  end # class
end # module
