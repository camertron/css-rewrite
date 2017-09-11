require 'spec_helper'

describe CssRewrite::Rewriter do
  let(:rewriter) { described_class.new(/application\.css$/, &block) }
  let(:block) { -> (url) { url.gsub(/\.png$/, '.foo') } }

  describe '#matches?' do
    it "returns false if the filename doesn't match" do
      expect(rewriter.matches?('something.js')).to eq(false)
    end

    it 'returns true if the filename matches' do
      expect(rewriter.matches?('application.css')).to eq(true)
    end
  end

  describe '#rewrite' do
    it 'uses the replacement block to modify the url' do
      expect(rewriter.rewrite('path/to/image.png')).to eq('path/to/image.foo')
    end
  end
end
