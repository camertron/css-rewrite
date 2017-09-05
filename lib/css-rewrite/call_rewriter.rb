module CssRewrite
  class CallRewriter
    def self.applies_to?(*args, &block)
      args.size == 0 && block.present?
    end

    attr_reader :replacement_block

    def initialize(&block)
      @replacement_block = block
    end

    def matches?(url)
      true
    end

    def rewrite(url, filename)
      replacement_block.call(url, filename)
    end
  end
end
