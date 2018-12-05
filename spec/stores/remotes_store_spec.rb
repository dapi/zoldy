# frozen_string_literal: true

require 'spec_helper'

describe RemotesStore do
  subject(:store) { described_class.new dir: Pathname(Settings.stores_dir).join('remotes') }

  before do
    store.clear!
  end

  specify { expect(store.remotes).to be_empty }

  context 'when remotes is empty' do
    let(:remote) { build :remote }

    specify do
      store.add remote
      expect(store.remotes).to include remote
    end
  end
end
