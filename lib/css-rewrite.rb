module CssRewrite
  autoload :CallRewriter,  'css-rewrite/call_rewriter'
  autoload :Config,        'css-rewrite/config'
  autoload :Postprocessor, 'css-rewrite/postprocessor'
  autoload :RegexRewriter, 'css-rewrite/regex_rewriter'
  autoload :Rewriter,      'css-rewrite/rewriter'

  def self.configure
    yield Config.instance
  end
end

require 'css-rewrite/railtie' if defined?(Rails)
