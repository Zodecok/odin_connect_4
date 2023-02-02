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
    end


    it "piece is added to board at correct location" do
      @connect.turn(0)
      expect(@connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_]])
    end

    it "piece changes to white for the second player's move" do
      @connect.turn(0)
      @connect.turn(2)
      expect(@connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚪, :_, :_, :_, :_]])
    end

    it "piece stacks on another if space below it is filled" do
      @connect.turn(0)
      @connect.turn(0)
      expect(@connect.board).to eql([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_]])
    end

    it "throws error when column index is out of range" do
      expect { @connect.turn(10) }.to raise_error(OutOfBoundsError)
    end

    it "throws error when column is too high" do
      6.times { @connect.turn(1) }
      expect { @connect.turn(1) }.to raise_error(OutOfBoundsError)
    end
  end

  describe "#game_over?" do
    it "returns false when the game isn't won" do
      connect = ConnectFour.new
      expect(connect.game_over?).to eql(false)
    end

    it "returns true when a horizontal win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚫, :_, :_, :_, :_],                                                                      
        [:⚫, :⚪, :⚪, :⚪, :⚪, :_, :_]], [5,1])
      expect(connect.game_over?).to eql(true)
    end

    it "returns true when a vertical win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚫, :⚪, :_, :_, :_],                                                                      
        [:⚫, :⚪, :⚪, :⚪, :_, :_, :_]], [2,0])
      expect(connect.game_over?).to eql(true)
    end

    it "returns true when a left diagonal win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :⚪, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :⚫, :⚪, :_, :_, :_, :_],                                                                      
        [:⚫, :⚫, :⚫, :⚪, :_, :_, :_]], [5,3])
      expect(connect.game_over?).to eql(true)
    end

    it "returns true when a right diagonal win" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :⚫],                                                                      
        [:_, :_, :_, :_, :_, :⚫, :⚪],                                                                      
        [:_, :_, :_, :_, :⚫, :⚪, :⚫],                                                                      
        [:_, :_, :⚫, :⚫, :⚪, :⚪, :⚪]], [2,6])
      expect(connect.game_over?).to eql(true)
    end
  end

  describe "winner" do
    it "returns nil when no winner" do 
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_]])
      expect(connect.winner).to eql(nil)
    end

    it "returns white token when player two wins" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :⚪, :_, :_, :_, :_, :_],                                                                      
        [:⚪, :⚫, :⚪, :_, :_, :_, :_],                                                                      
        [:⚫, :⚫, :⚫, :⚪, :_, :_, :_]], [5,3])
      expect(connect.winner).to eql(:⚪)
    end

    it "returns black token when player one wins" do
      connect = ConnectFour.new([[:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:_, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :_, :_, :_, :_, :_],                                                                      
        [:⚫, :_, :⚫, :⚪, :_, :_, :_],                                                                      
        [:⚫, :⚪, :⚪, :⚪, :_, :_, :_]], [2,0])
      expect(connect.winner).to eql(:⚫)
    end

  describe "#reset" do
    it "resests board to original" do
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