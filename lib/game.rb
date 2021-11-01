# frozen_string_literal: true

# core game logic
class Game
  def play_game
    establish_players
    randomize_colors
    generate_board
    generate_pieces
    loop do
      players[0].play_move
      return game_over_message if game_over == true

      players.rotate!
    end
  end
end
