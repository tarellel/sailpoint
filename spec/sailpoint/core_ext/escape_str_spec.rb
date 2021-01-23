# # frozen_string_literal: true

require 'spec_helper'
require 'sailpoint/core_ext/escape_str'

RSpec.describe 'core_ext::blank' do
  describe 'array, hash, nil' do
    it { expect([].escape_str).to eq('') }
    it { expect({}.escape_str).to eq('') }
    it { expect(nil.escape_str).to eq('') }
  end

  describe 'string' do
    it { expect('asdfghjkl'.escape_str).to eq('asdfghjkl') }
    it { expect('foo&bar'.escape_str).to eq('foo%26bar') }
    it { expect('foo bar'.escape_str).to eq('foo+bar') }
  end
end
