# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class PrivateWalletsStore < FileSystemStore
  def add(wallet)
    IO.write dir.join(wallet.id + '.pem'), wallet.private_key
  end

  def all
    Dir[dir].each do |file|
      binding.pry
      Pathname(file).basename
    end
  end
end
