require 'minitest/autorun'
require 'tcpsnitch_analyzer'

class TcpsnitchAnalyzerTest < Minitest::Test
  TRACE1 = './test/trace1.json'.freeze
  TRACE2 = './test/trace2.json'.freeze
  TRACE1_LENGTH = 9
  TRACE2_LENGTH = 11 

  def get_opts
    TcpsnitchAnalyzer::OptParser.default_options 
  end

  def test_default_options
    assert_equal(TcpsnitchAnalyzer.process_files(get_opts, [TRACE1]), TRACE1_LENGTH) 
  end

  def test_multiple_files
    assert_equal(TcpsnitchAnalyzer.process_files(get_opts, [TRACE1, TRACE2]), TRACE1_LENGTH+TRACE2_LENGTH) 
  end

  def test_filter
    opts = get_opts
    opts.event_filter = 'send'
    assert_equal(TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2]), 4) 
  end

  def test_descriptive
    opts = get_opts
    opts.event_filter = 'send'
    opts.analysis_type = TcpsnitchAnalyzer::DescriptiveStat 
    opts.node_path = 'details.bytes'
    opts.should_plot = false
    assert_equal(TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2]), 4) 
  end

  def test_timeserie
    opts = get_opts
    opts.event_filter = 'send'
    opts.analysis_type = TcpsnitchAnalyzer::TimeSerieStat 
    opts.node_path = 'details.bytes'
    opts.should_plot = false
    assert_equal(TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2]), 4) 
  end

  def test_proportion
    opts = get_opts
    opts.event_filter = 'send'
    opts.analysis_type = TcpsnitchAnalyzer::ProportionStat 
    opts.node_path = 'details.bytes'
    opts.should_plot = false
    assert_equal(TcpsnitchAnalyzer.process_files(opts, [TRACE1, TRACE2]), 4) 
  end
end
