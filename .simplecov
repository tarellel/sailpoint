require 'simplecov'
SimpleCov.start('rails') do
  add_filter('/bin/')
  add_filter('/cache/')
  add_filter('/docs/')
  add_filter('/lib/sailpoint/version.rb')
end
SimpleCov.minimum_coverage(75)
SimpleCov.use_merging(false)
