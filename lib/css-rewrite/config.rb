module CssRewrite
  class Config
    def self.instance
      @instance ||= new
    end

    def self.reset
      @instance = nil
    end

    attr_reader :rewriters

    def rewrite(*args, &block)
      rewriters << Rewriter.create(*args, &block)
    end

    private

    def initialize
      @rewriters = []
    end
  end
end
