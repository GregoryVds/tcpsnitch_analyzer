require 'minitest/autorun'
require 'tcpsnitch_analyzer'

class TcpsnitchAnalyzerTest < Minitest::Test
  TRACE1 = './test/trace1.json'.freeze
  TRACE2 = './test/trace2.json'.freeze
  TRACE1_LENGTH = 9
  TRACE2_LENGTH = 11 
  DEF_OPTIONS = TcpsnitchAnalyzer::OptParser.default_options 

  def test_default_options
    assert_equal(TcpsnitchAnalyzer.process_files(DEF_OPTIONS, [TRACE1]), TRACE1_LENGTH) 
  end

  def test_multiple_files
    assert_equal(TcpsnitchAnalyzer.process_files(DEF_OPTIONS, [TRACE1, TRACE2]), TRACE1_LENGTH+TRACE2_LENGTH) 
  end
end
