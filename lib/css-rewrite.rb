module CssRewrite
  autoload :Config,        'css-rewrite/config'
  autoload :Postprocessor, 'css-rewrite/postprocessor'
  autoload :Rewriter,      'css-rewrite/rewriter'

  def self.configure
    yield Config.instance
  end
end

require 'css-rewrite/railtie' if defined?(Rails)
