# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'cinch-bot_template/version'

Gem::Specification.new do |s|
  s.name          = "cinch-bot_template"
  s.version       = Cinch::BotTemplate::VERSION
  s.authors       = ["Ken Spencer"]
  s.email         = ["me@iotaspencer.me"]
  s.homepage      = "https://github.com/IotaSpencer/cinch-bot_template"
  s.summary       = "TODO: summary"
  s.description   = "TODO: description"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
end
