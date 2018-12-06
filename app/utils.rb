# frozen_string_literal: true

# Some development utils
#
class Utils
  def checker
    Zoldy.app.remotes_store.remotes.each do |remote|
      check remote
    end
    nil
  end

  def check(remote)
    if remote.client.remotes.map(&:to_s).include? Zoldy.app.mine_node.to_s
      puts "#{remote} includes #{Zoldy.app.mine_node}"
    else
      puts "#{remote} - none"
    end
  rescue StandardError => err
    puts "#{remote}: #{err}"
  end
end
