require 'spec_helper'

describe CssRewrite::RegexRewriter do
  describe '.applies_to?' do
    it 'applies if passed a regex and a block' do
      expect(described_class.applies_to?(/re/) {}).to eq(true)
    end

    it 'does not apply if passed no arguments' do
      expect(described_class.applies_to? {}).to eq(false)
    end

    it 'does not apply if not passed a block' do
      expect(described_class.applies_to?(/re/)).to eq(false)
    end
  end

  context 'with a rewriter' do
    subject { described_class.new(/.jpg\z/, &block) }

    let(:block) do
      # replaces the extension with ".foo"
      -> (url, filename) { url.chomp(File.extname(url)) + '.foo' }
    end

    describe '#matches?' do
      it 'matches if the regex matches' do
        expect(subject.matches?('foo.jpg')).to eq(true)
      end

      it 'does not match if the regex fails to match' do
        expect(subject.matches?('foo.png')).to eq(false)
      end
    end

    describe '#rewrite' do
      it 'invokes the replacement block' do
        expect(subject.rewrite('foo.com/image.jpg', 'foo.css')).to eq(
          'foo.com/image.foo'
        )
      end
    end
  end
end
