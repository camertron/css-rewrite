module CssRewrite
  class RegexRewriter
    def self.applies_to?(*args, &block)
      args.size == 1 && args.first.is_a?(Regexp) && block_given?
    end

    attr_reader :regex, :replacement_block

    def initialize(regex, &block)
      @regex = regex
      @replacement_block = block
    end

    def matches?(url)
      !!(regex =~ url)
    end

    def rewrite(url, filename)
      replacement_block.call(url, filename)
    end
  end
end
