class ConnectFour
  attr_reader :board
  BASE_VALUE = :_
  MAX_ROUNDS = 42
  WIDTH = 7
  HEIGHT = 6
  PLAYER_ONE_TOKEN = :"\u26AB"
  PLAYER_TWO_TOKEN = :"\u26AA"

  def initialize(board = Array.new(6) { Array.new(7, :_) })
    @board = board
  end

  def turn(column)
    raise OutOfBoundsError.new unless column.between(0,6)

    row_index = @board.transpose[column].reject { |el| el == BASE_VALUE }.size
    raise OutOfBoundsError.new if row_index > HEIGHT

    self.num_rounds.even? ? player = PLAYER_ONE_TOKEN : player = PLAYER_TWO_TOKEN
    @board[row_index][column] = player

    raise GameOver.new if self.game_over?
  end

  def winner

  end

  def game_over?
    self.num_rounds == MAX_ROUNDS || self.winner != nil
  end


  private
  def num_rounds
    @board.flatten.reject { |element| element == BASE_VALUE }.size
  end


end

class OutOfBoundsError < StandardError
end

class GameOver < StandardError
end


