# frozen_string_literal: true

require 'spec_helper'

describe Remote do
  subject { build :remote }

  specify { expect(subject.home).to be_present }
end
