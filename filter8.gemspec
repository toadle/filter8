Gem::Specification.new do |s|
  s.name                      = "filter8"
  s.version                   = "0.9.2"
  s.default_executable        = "filter8"

  s.authors                   = ["Tim Adler"]
  s.date                      = %q{2014-08-19}
  s.description               = %q{An unofficial ruby wrapper for Filter8 (http://filter8.com). An API to filter lots of stuff from texts, e.g. bad words.}
  s.summary                   = %q{An unofficial ruby wrapper for Filter8 (http://filter8.com). An API to filter lots of stuff from texts, e.g. bad words.}
  s.email                     = %q{mail (at) toadle (dot) me}
  s.license = "MIT"

  s.files                     = `git ls-files`.split("\n")
  s.test_files                = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage                  = %q{https://github.com/toadle/filter8}
  s.require_paths             = ["lib"]
  s.rubygems_version          = %q{1.6.2}

  s.add_dependency 'faraday'

  s.add_development_dependency 'rake', '~> 10.1.0'
  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'codeclimate-test-reporter'

end

