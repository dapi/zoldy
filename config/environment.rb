# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'production'

require File.expand_path('application', __dir__)

Dir[File.join(__dir__, 'initializers', '*.rb')].each { |file| require file }
