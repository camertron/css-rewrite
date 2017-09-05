# encoding: UTF-8

$:.push(File.dirname(__FILE__))

require 'rspec'
require 'pry-byebug'

require 'rails'
require 'rake'
require 'sprockets/railtie'

ENV['RAILS_ENV'] ||= 'test'

require 'css-rewrite'

Dir.chdir('spec') do
  require File.expand_path('../config/application', __FILE__)
  CssRewrite::DummyApplication.initialize!
  CssRewrite::DummyApplication.load_tasks  # used by precompilation specs
end

module LetDeclarations
  extend RSpec::SharedContext

  let(:app) { Rails.application }
  let(:assets) { app.assets }

  let(:assets_dir) do
    CssRewrite::DummyApplication.root.join('public/assets')
  end

  let(:tmp_dir) do
    CssRewrite::DummyApplication.root.join('tmp')
  end
end

RSpec.configure do |config|
  config.include(LetDeclarations)

  config.before do
    FileUtils.rm_rf(tmp_dir)
    FileUtils.rm_rf(assets_dir)
    FileUtils.mkdir_p(assets_dir)
  end

  config.after(:each) do
    CssRewrite::Config.reset
  end
end
