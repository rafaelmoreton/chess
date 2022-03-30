module Serialize
  require 'yaml'

  def save_game(game)
    puts "\nsave game as:"
    save_name = "savegames/#{gets.chomp}.yaml"
    serialized = YAML.dump(game)
    file = File.open(save_name, 'w')
    file.puts serialized
    file.close
    puts "game saved\n "
  end

  def load_game
    puts "\nsaved games list:"
    file_list = Dir.glob('savegames/*').map do |file_name|
      file_name[10..-6]
    end
    puts file_list.join("\n")
    puts "\nwhich game do you want to load?"
    load_name = "savegames/#{gets.chomp}.yaml"
    file = File.open(load_name, 'r')
    serialized = file.read
    file.close
    game = YAML.load(serialized)
    game.turn
  end
end
