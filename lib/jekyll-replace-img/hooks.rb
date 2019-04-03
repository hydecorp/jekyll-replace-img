# frozen_string_literal: true

KEY_CONFIG = "replace_img"
KEY_CONFIG_OLD = "replace_imgs"

KEY_RE_IMG      = "re_img"
KEY_RE_IGNORE   = "re_ignore"
KEY_REPLACEMENT = "replacement"

RE_IMG      = "<img\s*(?<attrs>.*?)\s*/>"
RE_IGNORE   = "data-ignore"
REPLACEMENT = "
  <hy-img %<attrs>s>
    <noscript><img data-ignore %<attrs>s/></noscript>
  </hy-img>"

RE_DATAURL = %r!src\s*=\s*[""]\s*data:!ix.freeze

re_img, re_ignore, replacement = nil

def get_config(config, key)
  plugin_config = config[KEY_CONFIG] || config[KEY_CONFIG_OLD]
  plugin_config && plugin_config[key]
end

Jekyll::Hooks.register(:site, :after_init) do |site|
  re_img = Regexp.new(
    get_config(site.config, KEY_RE_IMG) || RE_IMG,
    Regexp::EXTENDED | Regexp::IGNORECASE | Regexp::MULTILINE
  )

  re_ignore = Regexp.new(
    get_config(site.config, KEY_RE_IGNORE) || RE_IGNORE,
    Regexp::EXTENDED | Regexp::IGNORECASE
  )

  replacement = get_config(site.config, KEY_REPLACEMENT) || REPLACEMENT
  ENV["JEKYLL_ENV"] == "production" && replacement.gsub!(%r!\n+!, "")
end

Jekyll::Hooks.register([:pages, :documents], :post_render) do |page|
  i = 0
  page.output = page.output.gsub(re_img) do |match|
    last_match = Regexp.last_match

    subs = { :i => i }
    last_match.names.each do |name|
      subs[name.intern] = last_match[name]
    end

    if match.index(re_ignore).nil? && match.index(RE_DATAURL).nil?
      i += 1
      replacement % subs
    else
      match
    end
  end
end
