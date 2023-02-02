require 'pry-byebug'

class ConnectFour
  attr_reader :board
  BASE_VALUE = :_
  MAX_ROUNDS = 42
  WIDTH = 7
  HEIGHT = 6
  NUM_TO_WIN = 4
  PLAYER_ONE_TOKEN = :"\u26AB"
  PLAYER_TWO_TOKEN = :"\u26AA"
  # board goes row then column for indexing

  def initialize(board = Array.new(6) { Array.new(7, :_) }, last_move = nil)
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
    

    # raise GameOver.new if self.game_over?
  end

  def winner
    player_token = self.players_turn
    return nil if @last_move == nil 

    diagonal(@last_move, player_token)



  end

  



  def game_over?
    self.num_rounds == MAX_ROUNDS || self.winner != nil
  end


  private
  def num_rounds
    @board.flatten.reject { |element| element == BASE_VALUE }.size
  end

  def players_turn
    self.num_rounds.even? ? player = PLAYER_ONE_TOKEN : player = PLAYER_TWO_TOKEN
  end

  def diagonal(location, player_token, direction_of_former = nil)
    return 0 unless location[0].between?(0, HEIGHT - 1) && location[1].between?(0, WIDTH - 1)

    token_at_location = @board[location[0]][location[1]]
    return 0 unless token_at_location == player_token

    case direction_of_former
    when nil
      right_diagonal = 1 + diagonal([location[0] - 1, location[1] + 1], player_token, :right_above) + 
      diagonal([location[0] + 1, location[1] - 1], player_token, :left_below)

      left_diagonal = 1 + diagonal([location[0] - 1, location[1] - 1], player_token, :left_above) +
      diagonal([location[0] + 1, location[1] + 1], player_token, :right_below)

      return right_diagonal >= NUM_TO_WIN || left_diagonal >= NUM_TO_WIN

    when :right_above
      return 1 + diagonal([location[0] - 1, location[1] + 1], player_token, :right_above)
    when :left_below
      return 1 + diagonal([location[0] + 1, location[1] - 1], player_token, :left_below)
    when :left_above
      return 1 + diagonal([location[0] - 1, location[1] - 1], player_token, :left_above)
    when :right_below
      return 1 + diagonal([location[0] + 1, location[1] + 1], player_token, :right_below)
    end
  end


end

class OutOfBoundsError < StandardError
end

class GameOver < StandardError
end

