require 'spec_helper'

describe Sudoku::Board do
  before(:each) do
    @data = <<-TXT
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
      board = Sudoku::Board.build("1 2 3")
      board.should be_a(Sudoku::Board)
    end
    it "should build values with default delimeters" do
      values = @data.chomp.split("\n").map(&:split)
      board = Sudoku::Board.build(@data.chomp)
      values.each_with_index do |row, j|
        row.each_with_index do |value, k|
          board[j][k].should == value.to_i
        end
      end
    end
    it "should build values with optional delimeters" do
      data    = @data.chomp.gsub("\n", "|").gsub(" ", ",")
      values  = @data.chomp.split("\n").map(&:split)
      board   = Sudoku::Board.build(data, :row => "|", :val => ",")
      values.each_with_index do |row, j|
        row.each_with_index do |value, k|
          board[j][k].should == value.to_i
        end
      end
    end
  end
  
  describe "columns" do
    it "should map rows to columns" do
      board = Sudoku::Board.new
      board.rows = [
        [7, 6, 5, 1, 3, 8, 2, 9, 4],
        [4, 9, 1, 2, 7, 6, 5, 8, 3],
        [2, 8, 3, 4, 5, 9, 6, 1, 7],
        [9, 1, 4, 5, 8, 7, 3, 2, 6],
        [8, 5, 7, 3, 6, 2, 1, 4, 9],
        [3, 2, 6, 9, 4, 1, 7, 5, 8],
        [1, 7, 2, 8, 9, 3, 4, 6, 5],
        [6, 4, 8, 7, 2, 5, 9, 3, 1],
        [5, 3, 9, 6, 1, 4, 8, 7, 2]
      ]
      
      board.columns.should == [[7, 4, 2, 9, 8, 3, 1, 6, 5], [6, 9, 8, 1, 5, 2, 7, 4, 3], [5, 1, 3, 4, 7, 6, 2, 8, 9], [1, 2, 4, 5, 3, 9, 8, 7, 6], [3, 7, 5, 8, 6, 4, 9, 2, 1], [8, 6, 9, 7, 2, 1, 3, 5, 4], [2, 5, 6, 3, 1, 7, 4, 9, 8], [9, 8, 1, 2, 4, 5, 6, 3, 7], [4, 3, 7, 6, 9, 8, 5, 1, 2]]
    end
  end
  
  describe "copy" do
    it "should provide a new copy of the object and new copy of row data" do
      board = Sudoku::Board.new
      board.rows = [
        [7, 6, 5, 1, 3, 8, 2, 9, 4],
        [4, 9, 1, 2, 7, 6, 5, 8, 3],
        [2, 8, 3, 4, 5, 9, 6, 1, 7],
        [9, 1, 4, 5, 8, 7, 3, 2, 6],
        [8, 5, 7, 3, 6, 2, 1, 4, 9],
        [3, 2, 6, 9, 4, 1, 7, 5, 8],
        [1, 7, 2, 8, 9, 3, 4, 6, 5],
        [6, 4, 8, 7, 2, 5, 9, 3, 1],
        [5, 3, 9, 6, 1, 4, 8, 7, 2]
      ]
      copy = board.copy
      copy.should be_a(Sudoku::Board)
      copy.should_not == board
      copy.rows.object_id.should_not == board.rows.object_id
    end
  end
  
  describe "section" do
    it "should map rows to sections" do
      board = Sudoku::Board.new
      board.rows = [
        [7, 6, 5, 1, 3, 8, 2, 9, 4],
        [4, 9, 1, 2, 7, 6, 5, 8, 3],
        [2, 8, 3, 4, 5, 9, 6, 1, 7],
        [9, 1, 4, 5, 8, 7, 3, 2, 6],
        [8, 5, 7, 3, 6, 2, 1, 4, 9],
        [3, 2, 6, 9, 4, 1, 7, 5, 8],
        [1, 7, 2, 8, 9, 3, 4, 6, 5],
        [6, 4, 8, 7, 2, 5, 9, 3, 1],
        [5, 3, 9, 6, 1, 4, 8, 7, 2]
      ]
      board.sections.should == [
       [7, 6, 5, 4, 9, 1, 2, 8, 3],
       [1, 3, 8, 2, 7, 6, 4, 5, 9],
       [2, 9, 4, 5, 8, 3, 6, 1, 7],
       [9, 1, 4, 8, 5, 7, 3, 2, 6],
       [5, 8, 7, 3, 6, 2, 9, 4, 1],
       [3, 2, 6, 1, 4, 9, 7, 5, 8],
       [1, 7, 2, 6, 4, 8, 5, 3, 9], 
       [8, 9, 3, 7, 2, 5, 6, 1, 4], 
       [4, 6, 5, 9, 3, 1, 8, 7, 2]
      ]
    end
  end
  
  describe "complete?" do
    it "should return false if any values are unassigned" do
      board = Sudoku::Board.new
      board.complete?.should be_false
    end
    
    it "should return true if all values are assigned and valid" do
      board = Sudoku::Board.new
      board.rows = [
        [7, 6, 5, 1, 3, 8, 2, 9, 4],
        [4, 9, 1, 2, 7, 6, 5, 8, 3],
        [2, 8, 3, 4, 5, 9, 6, 1, 7],
        [9, 1, 4, 5, 8, 7, 3, 2, 6],
        [8, 5, 7, 3, 6, 2, 1, 4, 9],
        [3, 2, 6, 9, 4, 1, 7, 5, 8],
        [1, 7, 2, 8, 9, 3, 4, 6, 5],
        [6, 4, 8, 7, 2, 5, 9, 3, 1],
        [5, 3, 9, 6, 1, 4, 8, 7, 2]
      ]
      board.complete?.should be_true
    end
    
    it "should return false if board not valid" do
      board = Sudoku::Board.new
      invalid = [
        [7, 7, 5, 1, 3, 8, 2, 9, 4],
        [4, 9, 1, 2, 7, 6, 5, 8, 3],
        [2, 8, 3, 4, 5, 9, 6, 1, 7],
        [9, 1, 4, 5, 8, 7, 3, 2, 6],
        [8, 5, 7, 3, 6, 2, 1, 4, 9],
        [3, 2, 6, 9, 4, 1, 7, 5, 8],
        [1, 7, 2, 8, 9, 3, 4, 6, 5],
        [6, 4, 8, 7, 2, 5, 9, 3, 1],
        [5, 3, 9, 6, 1, 4, 8, 7, 2]
      ]
      board.rows = invalid
      board.complete?.should be_false
    end
  end
  
  describe "candidates" do
    it "should return possible values for given row/col indices" do
      pending
    end
  end
  
  describe "helpers" do
    before(:each) do
      @board = Sudoku::Board.build(@data)
    end
    describe "strip_row" do
      it "should return all values in row except given col index" do
        col_i = 2
        row_i = 0
        @board.strip_row(row_i, col_i).should == [7, 0, 0, 0, 0, 2, 9, 4]
      end
      it "should return not delete duplicates" do
        @board[0][1] = 7
        @board.strip_row(0, 0).should == [7, 5, 0, 0, 0, 2, 9, 4]
      end
    end
    describe "strip_col" do
      it "should return all values in col except given row index" do
        row_i = 4
        col_i = 0
        @board.strip_col(row_i, col_i).should == [7,0,0,9,0,1,0,5]
      end
      it "should not delete duplicates" do
        @board[4][0] = @board[3][0]
        @board.strip_col(4, 0).should == [7, 0, 0, 9, 0, 1, 0, 5]
      end
    end
    describe "strip_section" do
      it "should return all values in section except given row, col index" do
        row_i = 4
        col_i = 0
        @board.strip_section(row_i, col_i).should == [
        9, 0, 4,
           0, 7,
        0, 2, 0  
        ]
      end
    end
  end
end
