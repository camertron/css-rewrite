require 'spec_helper'

describe CssRewrite::Config do
  describe '.instance' do
    it 'returns the only instance' do
      expect(described_class.instance).to be_a(described_class)
      expect(described_class.instance.object_id).to(
        eq(described_class.instance.object_id)
      )
    end
  end

  describe '.reset' do
    it 'clears the existing instance' do
      old_config = described_class.instance
      described_class.reset
      expect(old_config.object_id).to_not(
        eq(described_class.instance.object_id)
      )
    end
  end

  context 'with a config instance' do
    subject { described_class.instance }

    describe '#rewrite' do
      it 'adds a call rewriter to the list of rewriters' do
        expect { subject.rewrite {} }.to change { subject.rewriters.size }.by(1)
        expect(subject.rewriters.first).to be_a(CssRewrite::CallRewriter)
      end

      it 'adds a regex rewriter to the list of rewriters' do
        expect { subject.rewrite(/re/) {} }.to change { subject.rewriters.size }.by(1)
        expect(subject.rewriters.first).to be_a(CssRewrite::RegexRewriter)
      end
    end
  end
end
