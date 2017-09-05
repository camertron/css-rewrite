module CssRewrite
  class Rewriter
    REWRITERS = [CssRewrite::RegexRewriter, CssRewrite::CallRewriter]

    def self.create(*args, &block)
      rewriter = REWRITERS.find do |rewriter|
        rewriter.applies_to?(*args, &block)
      end

      rewriter.new(*args, &block)
    end
  end
end
