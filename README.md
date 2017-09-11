## css-rewrite
Rewrite URLs in your 3rd-party CSS files using the asset pipeline.

## Installation

`gem install css-rewrite`

or put it in your Gemfile:

```ruby
gem 'css-rewrite'
```

## Rationale

Have you ever pulled a 3rd-party JavaScript or CSS library into your Rails web app? It can take some effort to get it to play nicely with the asset pipeline. You have to hunt through the tangle of potentially minified CSS to find all the URLs to images and fonts that should be using the Rails asset URL helpers. In other words, instead of this:

```css
.some-selector {
  background-image: url("puppy.png");
}
```

you want this:

```css
.some-selector {
  background-image: image-url("puppy.png");
}
```

Every time the author of the CSS library publishes a new version, you have to pull it down and do the hunt-and-replace thing all over again. How tedious.

That's where css-rewrite comes in. Rather than hunting for references to `url` by hand, css-rewrite adds a post-processor to the asset pipeline that finds and replaces `url`s for you. Whenever the file is served or precompiled, the URLs will magically point at the correct asset paths. No manual hunting or replacing necessary.

### Ok I'm listening. How does it work?

Behind the scenes, css-rewrite uses the [crass gem](https://github.com/rgrove/crass) to parse and reconstitute CSS. It searches through the parse tree crass generates looking for URLs. When it finds one, it yields it to you for replacement. You (or more accurately your application) can decide what the replacement URL should be using all the power afforded to you by the Ruby programming language.

## How 'bout some examples?

Sure! It's pretty straightforward. In an initializer (i.e. config/initializers/css_rewrite.rb), simply configure css-rewrite with a callback. Here's how you might configure it to resolve all URLs in application.css as if they were assets managed by the asset pipeline (which hopefully they are):

```ruby
CssRewrite.configure do |config|
  config.rewrite(/application\.css$/) do |url|
    ActionController::Base.helpers.asset_path(url)
  end
end
```

As you can see, the callback approach is pretty flexible; it gives you direct control over the replacement value of each URL. Here's another example that only replaces image URLs:

```ruby
CssRewrite.configure do |config|
  config.rewrite(/application\.css$/) do |url|
    if %w(.png .jpg .gif).include?(File.extname(url))
      ActionController::Base.helpers.image_path(url)
    end
  end
end
```

In this last example you'll notice that the block passed to `rewrite` can return `nil`. In such a case, css-rewrite will replace the URL with itself, i.e. won't change the URL at all. In addition, you can call `#rewrite` as many times as you want to set up different rewrite rules. When replacing URLs, css-rewrite will search through the rewriters that apply to the current file in the order they were added. The first one that returns something other than `nil` will be used for URL replacement. All the rewriters that come _after_ the matching one will be skipped. This happens on a per-URL basis.

## Nice! What else do I need to know?

That's pretty much it. The URL replacements should happen whenever the earmarked CSS files are requested by the browser or precompiled via `rake assets:precompile`.

## License

Licensed under the MIT license. See LICENSE for details.

## Authors

* Cameron C. Dutro: http://github.com/camertron
