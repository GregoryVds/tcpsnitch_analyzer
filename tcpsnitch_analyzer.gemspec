Gem::Specification.new do |s|
  s.name          = 'tcpsnitch_analyzer'
  s.version       = '0.0.1'
  s.date          = '2017-01-10'
  s.summary       = 'Tool to analyze tcpsnitch traces'
  s.description   = 'Accepts a single or multiple tcpsnitch JSON traces as argument and compute statistical information.'
  s.homepage      = 'https://github.com/GregoryVds/tcpsnitch_analyzer'
  s.authors       = ['Gregory Vander Schueren']
  s.email         = 'gregory.vanderschueren@gmail.com'
  s.license       = 'GPL-3.0' 
  s.files         = [
    'lib/tcpsnitch_analyzer.rb',
    'lib/tcpsnitch_analyzer/descriptive_stat.rb',
    'lib/tcpsnitch_analyzer/opt_parser.rb',
    'lib/tcpsnitch_analyzer/stat.rb',
    'lib/tcpsnitch_analyzer/proportion_stat.rb',
    'lib/tcpsnitch_analyzer/time_serie_stat.rb',
    'lib/tcpsnitch_analyzer/trace_parser.rb'
  ]
  s.executables << 'tcpsnitch_analyzer'
  s.add_runtime_dependency 'oj', '~> 2.18' 
  s.add_runtime_dependency 'descriptive_statistics', '~> 2.5'
  s.add_runtime_dependency 'gnuplot', '~> 2.6'
end
