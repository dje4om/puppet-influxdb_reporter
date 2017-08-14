source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem 'rake', '< 11.0'
  gem 'puppet', ENV['PUPPET_GEM_VERSION'] || '~> 3.8.0'
  gem 'rspec', '< 3.2.0'
  gem 'rspec-puppet'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint' if RUBY_VERSION >= '2.0.0'
  gem 'rspec-puppet-facts'
  if RUBY_VERSION < '2.0.0'
    gem 'rubocop', '<= 0.33.0'
  else
    gem 'rubocop', '0.43.0'
  end
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'
  gem 'semantic_puppet'
  gem 'public_suffix', '<= 1.4.6' if RUBY_VERSION < '2.0.0'
  gem 'safe_yaml', '~> 1.0.4' if RUBY_VERSION >= '2.2.0'

  gem "puppet-lint-absolute_classname-check"
  gem "puppet-lint-leading_zero-check"
  gem "puppet-lint-trailing_comma-check"
  gem "puppet-lint-version_comparison-check"
  gem "puppet-lint-classes_and_types_beginning_with_digits-check"
  gem "puppet-lint-unquoted_string-check"
  gem 'puppet-lint-resource_reference_syntax'

  gem 'json_pure', '<= 2.0.1' if RUBY_VERSION < '2.0.0'
end

group :development do
  gem "travis" if RUBY_VERSION >= '2.1.0'
  gem "travis-lint" if RUBY_VERSION >= '2.1.0'
  gem "puppet-blacksmith"
  gem "guard-rake" if RUBY_VERSION >= '2.2.5' # per dependency https://rubygems.org/gems/ruby_dep
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
  gem "beaker-puppet_install_helper"
end

