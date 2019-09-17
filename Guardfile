rspec_options = {
  version:        1,
  all_after_pass: false,
  all_on_start:   false
}

guard :rspec, cmd: 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

# guard :rubocop do
# guard :rubocop, cli: %w(--format fuubar --format html -o ./tmp/rubocop_results.html), launchy: './tmp/rubocop_results.html' do
guard :rubocop, cli: %w(--format fuubar) do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end

# Generates new Yard documentation as the files are changed
guard 'yard' do
  watch(%r{app\/.+\.rb})
  watch(%r{lib\/.+\.rb})
  watch(%r{ext\/.+\.c})
end
