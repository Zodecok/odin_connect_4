require "./lib/connect_4.rb"

describe ConnectFour do
  describe "#initialize" do
    it "has a board filled with underscores when created" do
      connect = ConnectFour.new
      expect(connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_]])
      end
    end

    it "has the board being equal to the input when given a parameter" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚪, :_, :_, :_, :_]])
      expect(connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚪, :_, :_, :_, :_]]) 
    end

  end

  describe "#turn" do

    before(:example) do
      @connect = ConnectFour.new


    xit "piece is added to board at correct location" do
      @connect.turn(0)
      expect(@connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_]])
    end

    xit "piece changes to white for the second player's move" do
      @connect.turn(0)
      @connect.turn(2)
      expect(@connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚪, :_, :_, :_, :_]])
    end

    xit "piece stacks on another if space below it is filled" do
      @connect.turn(0)
      @connect.turn(0)
      expect(@connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_]])
    end

    xit "throws error when column index is out of range" do
      expect { @connect.turn(10) }.to raise_error(StandardError::OutOfBoundsError)
    end

    xit "throws error when column is too high" do
      6.times { @connect.turn(1) }
      expect { @connect.turn(1) }.to raise_error(StandardError::OutOfBoundsError)
    end
  end

  describe "#game_over?" do
    xit "returns false when the game isn't won" do
      connect = ConnectFour.new
      expect(connect.game_over?).to eql(false)
    end

    xit "returns true when a horizontal win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚫, :_, :_, :_, :_],                                                                      
        [:⚫, :⚪, :⚪, :⚪, :⚪, :_, :_]])
      expect(connect.game_over?).to eql(true)
    end

    xit "returns true when a vertical win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚫, :⚪, :_, :_, :_],                                                                      
        [:⚫, :⚪, :⚪, :⚪, :_, :_, :_]])
      expect(connect.game_over?).to eql(true)
    end

    xit "returns true when a left diagonal win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :⚪, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :⚫, :⚪, :_, :_, :_, :_],                                                                      
        [:⚫, :⚫, :⚫, :⚪, :_, :_, :_]])
      expect(connect.game_over?).to eql(true)
    end

    xit "returns true when a right diagonal win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :⚫],                                                                      
        [:_, :_, :_, :_, :_, :⚫, :⚪],                                                                      
        [:_, :_, :_, :_, :⚫, :⚪, :⚫],                                                                      
        [:_, :_, :⚫, :⚫, :⚪, :⚪, :⚪]])
      expect(connect.game_over?).to eql(true)
    end
  end

  describe "winner" do
    xit "returns nil when no winner" do 
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_]])
      expect(connect.winner).to eql(nil)
    end

    xit "returns white token when player two wins" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :⚪, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :⚫, :⚪, :_, :_, :_, :_],                                                                      
        [:⚫, :⚫, :⚫, :⚪, :_, :_, :_]])
      expect(connect.winner).to eql(:⚪)
    end

    xit "returns black token when player one wins" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚫, :⚪, :_, :_, :_],                                                                      
        [:⚫, :⚪, :⚪, :⚪, :_, :_, :_]])
      expect(connect.winner).to eql(:⚫)
    end

  describe "#reset" do
    xit "resests board to original" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :⚫],                                                                      
        [:_, :_, :_, :_, :_, :⚫, :⚪],                                                                      
        [:_, :_, :_, :_, :⚫, :⚪, :⚫],                                                                      
        [:_, :_, :⚫, :⚫, :⚪, :⚪, :⚪]])
      connect.reset
      expect(connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_]])
    end
  end
end