require 'spec_helper'

describe CssRewrite::Rewriter do
  describe '.create' do
    it 'creates a call rewriter from the given args' do
      block = -> {}
      rewriter = described_class.create(&block)
      expect(rewriter).to be_a(CssRewrite::CallRewriter)
      expect(rewriter.replacement_block).to eq(block)
    end

    it 'creates a regex rewriter' do
      block = -> {}
      regex = /re/
      rewriter = described_class.create(regex, &block)
      expect(rewriter).to be_a(CssRewrite::RegexRewriter)
      expect(rewriter.replacement_block).to eq(block)
      expect(rewriter.regex).to eq(regex)
    end
  end
end
