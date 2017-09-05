$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'css-rewrite/version'

Gem::Specification.new do |s|
  s.name     = 'css-rewrite'
  s.version  = ::CssRewrite::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = 'http://github.com/camertron/css-rewrite'

  s.description = s.summary = 'Rewrite URLs in your 3rd-party CSS files using the asset pipeline.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'sprockets', '~> 3.0'
  s.add_dependency 'railties', '>= 4.0'
  s.add_dependency 'crass'

  s.require_path = 'lib'
  s.files = Dir['{lib,spec}/**/*', 'Gemfile', 'README.md', 'Rakefile', 'css-rewrite.gemspec']
end
