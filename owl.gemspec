# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'owl/version'

Gem::Specification.new do |gem|
  gem.name          = "owl"
  gem.version       = Owl::VERSION
  gem.summary       = %q{Summary}
  gem.description   = %q{Description}
  gem.license       = "MIT"
  gem.authors       = ["vladislav"]
  gem.email         = "v.yashin.work@gmail.com"
  gem.homepage      = "https://rubygems.org/gems/owl"

  gem.files         = `git ls-files`.split($/)

  `git submodule --quiet foreach --recursive pwd`.split($/).each do |submodule|
    submodule.sub!("#{Dir.pwd}/",'')

    Dir.chdir(submodule) do
      `git ls-files`.split($/).map do |subpath|
        gem.files << File.join(submodule,subpath)
      end
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency     'rails', '~> 5.1'
  gem.add_runtime_dependency     'browser', '>= 2.4.0'
  gem.add_runtime_dependency     'breadcrumbs_on_rails', '~> 3.0'
  gem.add_runtime_dependency     'i18n', '>= 0.7'

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'yard', '~> 0.8'
end
