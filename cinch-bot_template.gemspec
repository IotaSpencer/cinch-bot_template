# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'pathname'
require 'cinch/bot_template/version'

Gem::Specification.new do |s|
  s.name          = "cinch-bot_template"
  s.version       = Cinch::BotTemplate::VERSION
  s.authors       = ["Ken Spencer"]
  s.email         = ["me@iotaspencer.me"]
  s.homepage      = "https://github.com/IotaSpencer/cinch-bot_template"
  s.summary       = "Generate cinch bot skeletons"
  s.description   = s.summary
  s.license       = 'MIT'
  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.executables = Pathname('./bin').entries.map(&:to_s).delete_if { |x| %w(. ..).include?(x) }

  s.required_ruby_version = ['>= 2.3', '<= 3.0']


  s.add_runtime_dependency 'cinch', '~> 2.3'
  s.add_runtime_dependency 'activesupport', '~> 5.1'
  s.add_runtime_dependency 'thor', '~> 0.20'
  s.add_runtime_dependency 'highline', '~> 1.7', '>= 1.7.10'
  s.add_development_dependency 'bundler', '~> 1.16'
end
