# encoding: UTF-8

module CssRewrite
  class Railtie < ::Rails::Railtie
    config.assets.configure do |env|
      if env.respond_to?(:register_transformer)
        env.register_postprocessor 'text/css', 'text/css', CssRewrite::Postprocessor
      end

      if env.respond_to?(:register_engine)
        args = ['.css', CssRewrite::Postprocessor]

        if Sprockets::VERSION.start_with?('3')
          args << { mime_type: 'text/css', silence_deprecation: true }
        end

        env.register_engine(*args)
      end
    end
  end
end
