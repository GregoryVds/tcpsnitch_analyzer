require 'minitest/autorun'
require 'tcpsnitch_analyzer'

class TcpsnitchAnalyzerTest < Minitest::Test
  TRACE1 = File.dirname(__FILE__)+'/trace1.json'.freeze
  TRACE2 = File.dirname(__FILE__)+'/trace2.json'.freeze
  TRACE1_LENGTH = 9
  TRACE2_LENGTH = 11 

  def def_opts
    TcpsnitchAnalyzer::OptParser.default_options 
  end

  def test_trace_parser
    parser = TcpsnitchAnalyzer::TraceParser.new(def_opts, [TRACE1])
    assert_equal(TRACE1_LENGTH, parser.values.count)
  end
  
  def test_trace_parser_2_traces
    parser = TcpsnitchAnalyzer::TraceParser.new(def_opts, [TRACE1, TRACE2])
    assert_equal(TRACE1_LENGTH+TRACE2_LENGTH, parser.values.count)
  end

=begin
  def test_default_options
    assert_equal(TRACE1_LENGTH, TcpsnitchAnalyzer.process_files(get_opts, [TRACE1])) 
  end

  def test_multiple_files
    assert_equal(TRACE1_LENGTH+TRACE2_LENGTH, TcpsnitchAnalyzer.process_files(get_opts, [TRACE1, TRACE2])) 
  end

  def test_filter
    opts = get_opts
    opts.event_filter = 'send'
    assert_equal(4, TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2])) 
  end

  def test_descriptive
    opts = get_opts
    opts.event_filter = 'send'
    opts.analysis_type = TcpsnitchAnalyzer::DescriptiveStat 
    opts.node_path = 'details.bytes'
    opts.should_plot = false
    assert_equal(4, TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2])) 
  end

  def test_timeserie
    opts = get_opts
    opts.event_filter = 'send'
    opts.analysis_type = TcpsnitchAnalyzer::TimeSerieStat 
    opts.node_path = 'details.bytes'
    opts.should_plot = false
    assert_equal(4, TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2])) 
  end

  def test_proportion
    opts = get_opts
    opts.event_filter = 'send'
    opts.analysis_type = TcpsnitchAnalyzer::ProportionStat 
    opts.node_path = 'details.bytes'
    opts.should_plot = false
    assert_equal(4, TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2])) 
  end
=end
end
