# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'school_friend/version'

Gem::Specification.new do |gem|
  gem.name                  = 'school_friend'
  gem.version               = SchoolFriend::VERSION
  gem.authors               = 'Kostyantyn Stepanyuk'
  gem.email                 = 'kostya.stepanyuk@gmail.com'
  gem.description           = 'A Ruby interface to the Odnoklassniki API'
  gem.summary               = 'A Ruby interface to the Odnoklassniki API'
  gem.homepage              = 'https://github.com/kostyantyn/school_friend'
  gem.required_ruby_version = Gem::Requirement.new('>= 1.9.2')

  gem.files                 = `git ls-files`.split($/)
  gem.executables           = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths         = %w[lib]
end
