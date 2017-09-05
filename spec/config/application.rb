module CssRewrite
  class DummyApplication < ::Rails::Application
    config.eager_load = false
    config.active_support.deprecation = :stderr

    config.assets.enabled = true
    config.assets.compile = true
    config.assets.allow_debugging = true
    config.assets.digest = true
    config.assets.manifest = 'spec/public/assets/.sprockets-manifest.json'
  end
end
