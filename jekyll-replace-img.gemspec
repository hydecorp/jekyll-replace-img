# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "jekyll-replace-img/version"

Gem::Specification.new do |s|
  s.name          = "jekyll-replace-img"
  s.version       = JekyllReplaceImg::VERSION
  s.authors       = ["Florian Klampfer"]
  s.email         = ["mail@qwtel.com"]
  s.homepage      = "https://github.com/qwtel/jekyll-replace-img"
  s.summary       = "A Jekyll plugin to replace <img/> tags with custom elements."

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ["lib"]
  s.license       = "MIT"

  s.add_dependency "jekyll", ">= 3.3", "< 5.0"
  s.add_development_dependency "nokogiri", "~> 1.10"
  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "rubocop", ">= 0.49.0", "< 1.0.0"
  s.add_development_dependency "rubocop-jekyll", "~> 0.7.0"
end
