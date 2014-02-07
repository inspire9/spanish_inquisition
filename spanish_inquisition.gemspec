# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = 'spanish_inquisition'
  gem.version       = '1.1.0'
  gem.authors       = ['Pat Allan']
  gem.email         = ['pat@freelancing-gods.com']
  gem.summary       = 'Simple Ruby survey DSL'
  gem.description   = 'A simple Ruby survey DSL which handles questions and answers. You need to manage persistence yourself.'
  gem.homepage      = 'https://github.com/inspire9/spanish_inquisition'

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activemodel', '>= 3.2.0'
  gem.add_runtime_dependency 'formtastic',  '~> 2.2'
end
