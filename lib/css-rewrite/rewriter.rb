module CssRewrite
  class Rewriter
    attr_reader :file_filter, :replacement_block

    def initialize(file_filter, &block)
      @file_filter = file_filter
      @replacement_block = block
    end

    def matches?(filename)
      case file_filter
        when String
          file_filter == filename
        when Regexp
          !!(file_filter =~ filename)
        else
          if file_filter.respond_to?(:call)
            file_filter.call(filename)
          end
      end
    end

    def rewrite(url)
      replacement_block.call(url)
    end
  end
end
