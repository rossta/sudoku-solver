require 'spec_helper'

describe Sudoku::Solver do
  before(:each) do
    @data_1 = <<-TXT
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

@solution_1 = [
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

@data_2 = <<-TXT
8 0 0 0 0 4 0 0 1
0 0 0 0 0 0 0 0 0
0 3 2 0 5 0 4 9 0
0 0 5 0 0 8 3 0 0
3 0 0 6 1 9 0 0 5
0 0 1 3 0 0 6 0 0
0 8 4 0 7 0 1 2 0
0 0 0 0 0 0 0 0 0
7 0 0 2 0 0 0 0 4
TXT

@data_3 = <<-TXT
0 0 0 0 1 9 0 4 0
0 0 4 8 0 0 6 0 0
7 5 0 0 0 0 0 0 2
0 9 0 1 0 2 0 0 4
0 0 0 0 0 3 0 0 0
5 0 0 4 0 6 0 3 0
8 0 0 0 0 0 0 7 3
0 0 6 0 0 8 4 0 0
0 1 0 2 9 0 0 0 0 
TXT

@solution_3 = [
  [2,6,8,7,1,9,3,4,5],
  [1,3,4,8,2,5,6,9,7],
  [7,5,9,3,6,4,1,8,2],
  [3,9,7,1,8,2,5,6,4],
  [6,4,2,9,5,3,7,1,8],
  [5,8,1,4,7,6,2,3,9],
  [8,2,5,6,4,1,9,7,3],
  [9,7,6,5,3,8,4,2,1],
  [4,1,3,2,9,7,8,5,6]
]
  end

  describe "self.solve" do
    it "should fill in missing values for board" do
      Sudoku::Solver.solve(@data_1).should == @solution_1
    end
  end
  
  describe "solve!" do
    before(:each) do
      @solver = Sudoku::Solver.new(@data_1)
    end
    it "should fill in missing values for board 1" do
      @solver.solve!
      @solver.solution.should == @solution_1
    end
    it "should fill in missing values for board 2" do
      solver = Sudoku::Solver.new(@data_3)
      solver.solve!
      solver.solution.should == @solution_3
    end
  end
  
  describe "basic_sudoku" do
    before(:each) do
      @solver = Sudoku::Solver.new(@data_1)
    end
    it "should raise error if unsolvable" do
      @solver.board[0][3] = 6
      lambda { @solver.basic_sudoku(@solver.board) }.should raise_error(Sudoku::UnsolvableSudokuError)
    end
  end

end
