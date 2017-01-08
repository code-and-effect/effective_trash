$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'effective_trash/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'effective_trash'
  s.version     = EffectiveTrash::VERSION
  s.email       = ['info@codeandeffect.com']
  s.authors     = ['Code and Effect']
  s.homepage    = 'https://github.com/code-and-effect/effective_trash'
  s.summary     = 'Trash and Restore any Active Record object.'
  s.description = 'Trash and Restore any Active Record object.'
  s.licenses    = ['MIT']

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  s.add_dependency 'rails', ['>= 3.2.0']
  s.add_dependency 'effective_datatables', '>= 2.0.0'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'devise'
  s.add_dependency 'haml-rails'

end
