# frozen_string_literal: true

require 'simplecov'
SimpleCov.start('rails') do
  add_filter('/bin/')
  add_filter('/cache/')
  add_filter('/docs/')
  add_filter('/lib/sailpoint/version.rb')
end
SimpleCov.minimum_coverage(70)
SimpleCov.use_merging(false)
