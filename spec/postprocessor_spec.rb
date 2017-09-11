require 'spec_helper'

describe CssRewrite::Postprocessor do
  describe '.run' do
    before do
      CssRewrite.configure do |config|
        config.rewrite(/application\.css$/) { |url| nil }
      end
    end

    let(:filename) { Rails.root.join(*%w(app assets stylesheets application.css)).to_s }
    let(:source) { File.read(filename) }
    let(:context) { nil }

    subject { described_class.run(filename, source, context) }

    it 'defaults to using the original url' do
      expect(subject).to eq(source)
    end

    context 'with more rewriters' do
      before do
        CssRewrite.configure do |config|
          config.rewrite(/application\.css$/) do |url|
            if url.end_with?('.png')
              url.gsub(/\.png/, '.foo')
            end
          end

          config.rewrite(/application\.css$/) do |url|
            if url.end_with?('.jpg')
              url.gsub(/\.jpg/, '.bar')
            end
          end
        end
      end

      it 'stops after finding a matching rewriter' do
        expect(subject).to(
          eq(".my-class {\n  background-image: url('foo/bar.foo');\n}\n")
        )
      end
    end
  end
end
