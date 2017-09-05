require 'spec_helper'

describe CssRewrite::CallRewriter do
  describe '.applies_to?' do
    it 'applies if passed a block' do
      expect(described_class.applies_to? {}).to eq(true)
    end

    it 'does not apply if passed any arguments' do
      expect(described_class.applies_to?(1) {}).to eq(false)
    end

    it 'does not apply if not passed a block' do
      expect(described_class.applies_to?).to eq(false)
    end
  end

  context 'with a rewriter' do
    subject { described_class.new(&block) }

    let(:block) do
      # replaces the extension with ".foo"
      -> (url, filename) { url.chomp(File.extname(url)) + '.foo' }
    end

    describe '#matches?' do
      it 'always matches' do
        expect(subject.matches?('foo')).to eq(true)
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
