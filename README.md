## css-rewrite
Rewrite URLs in your 3rd-party CSS files using the asset pipeline.

## Installation

`gem install css-rewrite`

or put it in your Gemfile:

```ruby
gem 'css-rewrite'
```

### Rationale

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

Behind the scenes, css-rewrite uses the [crass gem](https://github.com/rgrove/crass) to parse and reconstitute CSS. It searches through the parse tree crass generates looking for references to `url`. When it finds one, it yields it to you for analysis. You (or more accurately, your application) can decide what the replacement URL should be.

### How 'bout some examples?

Sure! There are two different ways of matching URLs to rewrite: 1) using a regex, and 2) manually.

#### Rewriting using Regexes

In an initializer (i.e. config/initializers/css_rewrite.rb), all you have to do is configure css-rewrite with a regex:

```ruby
CssRewrite.configure do |config|
  config.rewrite(/\.png$/) do |url, filename|
    if filename == '3rd_party_lib/everything.css'
      # grab the correct URL from Rails
      ActionController::Base.helpers.image_path(url)
    else
      # return the original url if filename doesn't match
      url
    end
  end
end
```
