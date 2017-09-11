module CssRewrite
  class Config
    def self.instance
      @instance ||= new
    end

    def self.reset
      @instance = nil
    end

    attr_reader :rewriters

    def rewrite(file_filter, &block)
      rewriters << Rewriter.new(file_filter, &block)
    end

    private

    def initialize
      @rewriters = []
    end
  end
end
