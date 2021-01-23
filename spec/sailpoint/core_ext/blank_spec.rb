# # frozen_string_literal: true

require 'spec_helper'
require 'sailpoint/core_ext/blank'

RSpec.describe 'core_ext::blank' do
  describe 'string' do
    it { expect(''.present?).to be_falsey }
  end

  describe 'array & hash' do
    it { expect([].present?).to be_falsey }
    it { expect({}.present?).to be_falsey }
  end

  describe 'boolean' do
    it { expect(true.present?).to be_truthy }
    it { expect(false.present?).to be_falsey }
  end
end
