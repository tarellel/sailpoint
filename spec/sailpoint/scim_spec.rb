# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sailpoint::Scim do
  describe 'when nil' do
    it { expect(nil).to be_falsy }
  end
end
