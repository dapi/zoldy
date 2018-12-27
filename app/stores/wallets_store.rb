# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'digest'

# Store ::Remote info filesystem
#
#
# TODO move score's manimulation to difference store
#
class WalletsStore < FileSystemStore
  include WalletsStorePaths

  WalletNotFound = Class.new StandardError

  def save_copy!(wallet, score = nil)
    if copy? wallet
      touch_remote_modification wallet.id, score.node_alias if score.present?
      return
    end

    save_wallet! wallet
    save_score! wallet, score if score.present?
    select_best! wallet.id
  end

  def wallet_size(id)
    File.size build_best_wallet_dir(id).join('body')
  rescue Errno::ENOENT
    raise WalletNotFound
  end

  def copy?(other_wallet)
    Dir.exist? build_wallet_copy_dir other_wallet
  end

  def exists?(id)
    Dir.exist? build_wallet_dir(id)
  end

  def find!(id)
    Wallet.load IO.read(build_best_wallet_dir(id).join('body'))
  rescue Errno::ENOENT
    raise WalletNotFound
  end

  def find(id)
    find! id
  rescue WalletNotFound
    nil
  end

  def count
    Dir[all_best_dir].count
  end

  def each
    Dir[all_best_dir].lazy.each do |file|
      yield Wallet.load File.read file
    end
  end

  def save_score!(wallet, score)
    wallet_copy_dir = build_wallet_copy_dir wallet
    IO.write wallet_copy_dir.join(validate_path!(score.node_alias) + '.score'), score.value
    IO.write wallet_copy_dir.join('total_scores'), calculate_total_scores_in_wallet_directory(wallet_copy_dir)
  end

  private

  def select_best!(id)
    id = id.id if id.is_a? Wallet

    best_copy_path = Pathname(find_path_of_best_copy(id)).basename
    best_dir = build_best_wallet_dir(id)

    return if Dir.exist?(best_dir) && File.readlink(best_dir) == best_copy_path

    create_symlink best_copy_path, best_dir
  end

  def find_path_of_best_copy(id)
    Dir[build_wallet_dir(id).join '*.copy'].max_by do |file|
      begin
        File.read Pathname(file).join('total_scores')
      rescue Errno::ENOENT
        0
      end.to_i
    end
  end

  def create_symlink(dir, target)
    system "ln -sfn #{dir} #{target}"
    raise "Error (#{$CHILD_STATUS}) symlinking #{dir} to #{target}" unless $CHILD_STATUS.success?
  end

  def total_scores_of_copy(wallet)
    wallet_copy_dir = build_wallet_copy_dir wallet
    calculate_total_scores_in_wallet_directory wallet_copy_dir
  end

  def calculate_total_scores_in_wallet_directory(dir)
    Dir[dir.join('*.score')].map { |f| File.read(f).to_i }.inject(&:+)
  end

  def save_wallet!(wallet)
    wallet_copy_dir = build_wallet_copy_dir wallet
    FileUtils.mkdir_p wallet_copy_dir
    IO.write wallet_copy_dir.join('body'), wallet.body
  end
end
