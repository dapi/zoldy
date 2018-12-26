# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

ignore %r{^.zoldy/}
ignore %r{^/tmp/}

directories %w[app config lib spec]

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

guard 'ctags-bundler', src_path: %w[app lib] do
  watch(%r{^(app|lib)\/.*\.rb$})
  watch('Gemfile.lock')
end

# Usage:
#     guard :foreman, <options hash>
#
# Possible options:
# * :concurreny - how many of each type of process you would like to run (default is, sensibly, one of each)
# * :env - one or more .env files to load
# * :procfile - an alternate Procfile to use (default is Procfile)
# * :port - an alternate port to use (default is 5000)
# * :root - an alternate application root
if ENV['FOREMAN']
  guard :foreman, procfile: 'Procfile.dev' do
    # Rails example - Watch controllers, models, helpers, lib, and config files
    watch(%r{^app\/.+\/.+\.rb$})
    watch(%r{^lib\/.+\.rb$})
    watch(%r{^config\/*})
  end
end

group :red_green_refactor, halt_on_fail: true do
  guard :rspec, cmd: 'bundle exec rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { 'spec' }
  end

  guard :rubocop do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
  end
end
