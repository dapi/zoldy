# frozen_string_literal: true

require 'spec_helper'

describe RemotesStore do
  subject(:store) { RemotesStore.new dir: Pathname(Settings.stores_dir).join('remotes') }

  before do
    store.clear!
  end

  specify { expect(store.remotes).to be_empty }

  context 'adds remote' do
    let(:remote) { build :remote }

    specify do
      store.add remote
      expect(store.remotes).to include remote
    end
  end
end
