$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "common_core_parser/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "common_core_parser"
  s.version = CommonCoreParser::VERSION
  s.authors = ['Aaron Baldwin', 'Jonathan S. Garvin', 'WWIDEA, Inc']
  s.email = ["developers@wwidea.org"]
  s.homepage = "https://github.com/wwidea/common_core_parser"
  s.summary = "Parses common core standrds xml files and returns ruby objects."
  s.description = "The common core standards xml files and pdf docs are provided by the Common Core State Standards Initiative."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'nokogiri', '>= 1.5.5'
  s.add_dependency 'rake', '>= 0.9.2'

  s.add_development_dependency 'rdoc', '>= 3.12'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'mocha'

end
