require 'crass'

module CssRewrite
  class Postprocessor
    class << self
      def run(filename, source, context)
        rewriters = find_rewriters(filename)
        return source if rewriters.empty?
        tree = Crass.parse(source, preserve_comments: true)

        replace_urls(tree) do |url|
          rewritten_url = nil

          rewriters.each do |rewriter|
            rewritten_url = rewriter.rewrite(url)
            break if rewritten_url
          end

          rewritten_url || url
        end

        Crass::Parser.stringify(tree)
      end

      def call(input)
        filename = input[:filename]
        source   = input[:data]
        context  = input[:environment].context_class.new(input)

        result = run(filename, source, context)
        context.metadata.merge(data: result)
      end

      private

      def find_rewriters(filename)
        Config.instance.rewriters.select do |re|
          re.matches?(filename)
        end
      end

      def replace_urls(root, &block)
        return unless root

        root.each do |node|
          if node[:node] == :url
            new_value = yield node[:value]
            node[:raw].sub!(node[:value], new_value)
            node[:value] = new_value
          elsif node[:node] == :function && node[:name] == 'url'
            old_value = node[:value].first[:value]
            new_value = yield old_value
            node[:value].first[:value] = new_value
            node[:value].first[:raw].sub!(old_value, new_value)
          end

          replace_urls(node[:children], &block)
          replace_urls(node[:block], &block)
        end
      end
    end

    def initialize(filename, &block)
      @filename = filename
      @source = block.call
    end

    def render(context, empty_hash_wtf)
      self.class.run(@filename, @source, context)
    end
  end
end
