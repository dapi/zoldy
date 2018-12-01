# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Initialize default application data in stores
#
class Defaults
  def perform
    make_default_remotes
  end

  private

  def make_default_remotes
    Zoldy.app.remotes_store.add(
      Settings.default_remotes.map { |r| Remote.parse r }
    )
  end
end
