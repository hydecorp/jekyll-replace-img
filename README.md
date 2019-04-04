# Jekyll Replace Image

[![Build Status](https://travis-ci.org/qwtel/jekyll-replace-img.svg?branch=master)](https://travis-ci.org/qwtel/jekyll-replace-img)

A Jekyll plugin to replace `img` tags with custom elements.


## What it does

It runs a regular expression to find HTML `img` tags against the output of each page and replaces matches with a user-defined replacement. 

There are a number of custom elements you can use, such as [`progressive-img`][pi], [`amp-img`][ai] and (my very own) [`hy-img`][hy].

[io]: https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API
[pi]: https://www.webcomponents.org/element/progressive-img
[ai]: https://www.ampproject.org/docs/reference/components/amp-img
[hy]: https://github.com/qwtel/hy-img

Note that replacing images during site generation is necessary for lazy-loading, because the browser will start loading any `img` tag as soon as it is parsed, before it can be touched by client side code.

## Why

1. Lazy-loading images increases page load speed and is recommended by Google.
2. So you can use the `![alt](src)` syntax for images without polluting your posts with lengthy HTML tags.

## Usage

1.  Add the following to your site's Gemfile:

    ```ruby
    gem 'jekyll-replace-img'
    ```

2.  Add the following to your site's config file:

    ```yml
    plugins:
      - jekyll-replace-img
    ```
    Note: If you are using a Jekyll version less than 3.5.0, use the `gems` key instead of `plugins`.
  
3.  Configure and provide your replacement.

## Configuration

You can configure this plugin in `_config.yml` under the `replace_img` key. The defaults are:

```yml
replace_img:
  re_img:      <img\\s*(?<attributes>.*?)\\s*/>
  re_ignore:   data-ignore
  replacement: |
    <hy-img %<attributes>s>
      <noscript><img data-ignore %<attributes>s/></noscript>
    </hy-img>"
```

### Image Regular Expression
You can set the `re_img` key to a custom regular expression to look for image tags (or possibly other tags). Note that the capture groups need to be named and match the names in `replacement`. 

You cannot provide flags and the regular expression is always case-insensitive.

### Ignore Regular Expression
You can provide a custom regular expression on the `re_ignore` key that will run against the text matched by the `re_img` expression. If it matches, the image will not be replaced. 

You cannot provide flags and the regular expression is always case-insensitive. Data URLs are always ignored.

### Replacement

A replacement string for every sequence matched by `re_img` but not `re_ignore`. Has access to the named captures in `re_img`, which is `attributes` by default. 

Capture groups can be inserted in the replacement like this `%<attributes>s`, where `attribures` is the name of the capture group and `s` is the string tag. See Ruby's [`sprintf`][sprintf] documentation for more. 

[sprintf]: https://ruby-doc.org/core-2.6.2/Kernel.html#method-i-sprintf

#### Example

    <progressive-img %<attributes>s></progressive-img>
    <noscript><img data-ignore %<attributes>s/></noscript>


## TODO

- [ ] Allow multiple ignore expressions
- [ ] Allow substitutions of matched groups, e.g. `s/width/w`
