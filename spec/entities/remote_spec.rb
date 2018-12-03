# frozen_string_literal: true

require 'spec_helper'

describe Remote do
  subject(:remote) { build :remote }

  specify { expect(remote.home).to be_present }
end
