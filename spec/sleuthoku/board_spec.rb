require 'spec_helper'

describe Sleuthoku::Board do
  before(:each) do
    @board_data = <<-TXT
7 0 5 0 0 0 2 9 4
0 0 1 2 0 6 0 0 0
0 0 0 0 0 0 0 0 7
9 0 4 5 0 0 0 2 0
0 0 7 3 6 2 1 0 0
0 2 0 0 0 1 7 0 8
1 0 0 0 9 0 0 0 0
0 0 0 7 0 5 9 0 0
5 3 9 0 0 0 8 0 2
TXT
  end
  describe "self.build" do
    it "should return a board" do
      board = Sleuthoku::Board.build("1 2 3")
      board.should be_a(Sleuthoku::Board)
    end
    it "should build values with default delimeters" do
      values = @board_data.chomp.split("\n").map(&:split)
      board = Sleuthoku::Board.build(@board_data.chomp)
      values.each_with_index do |row, j|
        row.each_with_index do |value, k|
          board[j][k].should == value.to_i
        end
      end
    end
    it "should build values with optional delimeters" do
      data    = @board_data.chomp.gsub("\n", "|").gsub(" ", ",")
      values  = @board_data.chomp.split("\n").map(&:split)
      board   = Sleuthoku::Board.build(data, :row => "|", :val => ",")
      values.each_with_index do |row, j|
        row.each_with_index do |value, k|
          board[j][k].should == value.to_i
        end
      end
    end
  end
end
