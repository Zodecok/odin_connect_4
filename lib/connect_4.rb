require 'pry-byebug'
require 'msgpack'
require 'json'

class ConnectFour
  attr_reader :board, :last_move
  BASE_VALUE = "_"
  MAX_ROUNDS = 42
  WIDTH = 7
  HEIGHT = 6
  NUM_TO_WIN = 4
  PLAYER_ONE_TOKEN = "\u26AB"
  PLAYER_TWO_TOKEN = "\u26AA"
  # board goes row then column for indexing

  def initialize(board = Array.new(HEIGHT) { Array.new(WIDTH, BASE_VALUE) }, last_move = nil)
    @board = board
    @last_move = last_move
  end

  def turn(column)
    raise OutOfBoundsError.new unless column.between?(0, WIDTH - 1)

    row_index = @board.transpose[column].reject { |el| el == BASE_VALUE }.size
    raise OutOfBoundsError.new if row_index > (HEIGHT - 1)
    @last_move = [(HEIGHT - 1) - row_index, column]

    player_token = self.players_turn

    @board[@last_move[0]][@last_move[1]] = player_token
    raise GameOver.new if self.game_over?
  end

  def winner
    player_token = self.last_players_turn
    return nil if @last_move == nil
    return player_token if match(@last_move, player_token) == true
  end

  def game_over?
    self.num_rounds == MAX_ROUNDS || self.winner != nil
  end

  def reset
    @board = Array.new(6) { Array.new(7, BASE_VALUE) }
  end

  private
  def num_rounds
    @board.flatten.reject { |element| element == BASE_VALUE }.size
  end

  def players_turn
    self.num_rounds.even? ? player = PLAYER_ONE_TOKEN : player = PLAYER_TWO_TOKEN
  end

  def last_players_turn
    self.num_rounds.even? ? player = PLAYER_TWO_TOKEN : player = PLAYER_ONE_TOKEN
  end

  def match(location, player_token, direction_heading = nil)
    # binding.pry
    return 0 unless location[0].between?(0, HEIGHT - 1) && location[1].between?(0, WIDTH - 1)

    token_at_location = @board[location[0]][location[1]]
    return 0 unless token_at_location == player_token

    case direction_heading
    when nil
      right_diagonal = 1 + match([location[0] - 1, location[1] + 1], player_token, :right_above) + 
      match([location[0] + 1, location[1] - 1], player_token, :left_below)
      return true if right_diagonal >= NUM_TO_WIN

      left_diagonal = 1 + match([location[0] - 1, location[1] - 1], player_token, :left_above) +
      match([location[0] + 1, location[1] + 1], player_token, :right_below)
      return true if left_diagonal >= NUM_TO_WIN

      horizontal = 1 + match([location[0], location[1] - 1], player_token, :left) +
      match([location[0], location[1] + 1], player_token, :right)
      return true if horizontal >= NUM_TO_WIN

      vertical = 1 + match([location[0] - 1, location[1]], player_token, :above) + 
      match([location[0] + 1, location[1]], player_token, :below)
      return true if vertical >= NUM_TO_WIN

      return false

    when :right_above
      return 1 + match([location[0] - 1, location[1] + 1], player_token, :right_above)
    when :left_below
      return 1 + match([location[0] + 1, location[1] - 1], player_token, :left_below)
    when :left_above
      return 1 + match([location[0] - 1, location[1] - 1], player_token, :left_above)
    when :right_below
      return 1 + match([location[0] + 1, location[1] + 1], player_token, :right_below)
    when :left
      return 1 + match([location[0], location[1] - 1], player_token, :left)
    when :right
      return 1 + match([location[0], location[1] + 1], player_token, :right)
    when :above
      return 1 + match([location[0] - 1, location[1]], player_token, :above)
    when :below
      return 1 + match([location[0] + 1, location[1]], player_token, :below)
    end
  end
end

class Controller

  def main(connect_4 = ConnectFour.new)
    display = Display.new
    display.greeting

    connect_4 = to_load(connect_4, display)

    self.running_turns(connect_4, display)

    winner_token = connect_4.winner
    display.write_message("The winner was #{winner_token.to_s}")
    self.main if display.get_input("Press 'y' to play again") == 'y'
  end
  
  def to_load(connect_4, display)
    input = display.get_input("If you want to load a saved file, press 'l', otherwise press anything else")
    return connect_4 unless input == 'l'
    save_number = display.get_input("What was the number of the save?")
    filepath = "./lib/saves/connect_4_save_#{save_number}.json"
    return self.loader(connect_4, display, filepath)
  end

  def running_turns(connect_4, display)
    game_over_error_raised = false
    until game_over_error_raised
      begin
        display.write_board(connect_4.board)
        input = display.get_input("Enter column for go")
        if input == 'q'
          self.save(connect_4, display)
          exit
        end
        column = input.to_i
        begin
          connect_4.turn(column)
        rescue OutOfBoundsError => exception
          display.write_message("\n\nThis number is out of bounds")
          next
        end
      rescue GameOver => exception
        display.write_board(connect_4.board)
        game_over_error_raised = true
      end
    end
  end

  def save(connect_4, display)
    save_number = display.get_input("You have chosen to save, press a number for the number of the save you want").to_i
    content = JSON.dump ({
      :board => connect_4.board,
      :last_move => connect_4.last_move
    })
    File.open("./lib/saves/connect_4_save_#{save_number}.json", "w") { |file| file.puts content }
  end

  def loader(connect_4, display, filepath)
    begin
      raise NoFileError.new unless File.exist?(filepath)
      data = JSON.load(File.read(filepath))
      return ConnectFour.new(data['board'], data['last_move'])
    rescue NoFileError => exception
      display.write_message("This is not a save")
      return to_load(connect_4, display)
    end
  end



end

class Display

  def write_board(board)
    text = "\n"
    board.each do |row|
      indent = ""
      row.each do |element|
        text += indent + element.to_s
        indent = "\t"
      end
      text += "\n\n"
    end
    text += "0\t1\t2\t3\t4\t5\t6\n"
    puts text
  end

  def greeting
    message = "Welcome to connect 4, this is a normal connect four"
    message += "\nYou will need to enter the number of the column you want to place your token"
    message += "\nIf your answer is unacceptable a token will be placed in the first slot"
    message += "\nYou will take in turns with black going first"
    puts message
  end

  def get_input(message)
    puts message
    gets.chomp
  end

  def write_message(message)
    puts message
  end
end



class OutOfBoundsError < StandardError
end

class GameOver < StandardError
end

class NoFileError < StandardError
end

controller = Controller.new
controller.main