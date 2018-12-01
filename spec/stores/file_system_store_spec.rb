# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe FileSystemStore do
  subject(:store) { described_class.new dir: Pathname(Settings.stores_dir).join('test') }

  context 'when path is unsafe' do
    it { expect { store.send :validate_path!,  '/adas' }.to raise_error FileSystemStore::UnsafePathError }
    it { expect { store.send :validate_path!,  '..das' }.to raise_error FileSystemStore::UnsafePathError }
  end

  context 'when path is safe' do
    it { expect(store.send(:validate_path!, 'adas123-:')).to be_truthy }
  end
end
