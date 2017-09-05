require 'spec_helper'

describe 'Asset precompile' do
  def precompile!
    Rake::Task['assets:precompile'].reenable
    Rake::Task['assets:precompile'].invoke
  end

  before do
    CssRewrite.configure do |config|
      config.rewrite do |url, filename|
        url.chomp(File.extname(url)) + '.foo'
      end
    end
  end

  let(:manifest_file) { app.config.assets.manifest }

  it 'replaces urls in precompiled css assets' do
    precompile!

    manifest = JSON.parse(File.read(manifest_file))
    css_file = manifest['assets']['application.css']
    css_path = File.join('spec', 'public', app.config.assets.prefix, css_file)
    css = File.read(css_path)

    expect(css).to eq(
      ".my-class {\n  background-image: url('foo/bar.foo');\n}\n"
    )
  end
end
