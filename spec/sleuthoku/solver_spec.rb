require 'spec_helper'

describe Sleuthoku::Solver do
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
  end

  describe "self.solve" do
    it "should fill in missing values for board" do
      pending
      Sleuthoku::Solver.solve(@data_1).should == @solution_1
    end
  end
  
  describe "solve!" do
    before(:each) do
      @solver = Sleuthoku::Solver.new(@data_1)
    end
    it "should fill in missing values for board 1" do
      @solver.solve!
      @solver.solution.should == @solution_1
    end
    it "should fill in missing values for board 2" do
      pending
      solver = Sleuthoku::Solver.new(@data_2)
      solver.solve!
      solver.solution.should == @solution_1
    end
    it "should raise error if unsolvable" do
      @solver.board[0][3] = 6
      lambda { @solver.solve! }.should raise_error(Sleuthoku::UnsolvableSudokuError)
    end
    it "should raise error if constraints broken" do
      @solver.board[0][1] = 7
      lambda { @solver.solve! }.should raise_error(Sleuthoku::ViolatedSudokuError)
    end
    
  end
  
  describe "helpers" do
    before(:each) do
      @solver = Sleuthoku::Solver.new(@data_1)
    end
    describe "strip_row" do
      it "should return all values in row except given col index" do
        col_i = 4
        vals = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        @solver.strip_row(col_i, vals).should == [1, 2, 3, 4, 6, 7, 8, 9]
      end
      it "should return not delete duplicates" do
        col_i = 4
        vals = [1, 2, 3, 4, 5, 5, 7, 8, 9]
        @solver.strip_row(col_i, vals).should == [1, 2, 3, 4, 5, 7, 8, 9]
      end
    end
    describe "strip_col" do
      it "should return all values in col except given row index" do
        row_i = 4
        col_i = 0
        @solver.strip_col(row_i, col_i, @solution_1).should == [7,4,2,9,3,1,6,5]
      end
      it "should not delete duplicates" do
        @solution_1[5][0] = @solution_1[4][0]
        @solver.strip_col(4, 0, @solution_1).should == [7,4,2,9,8,1,6,5]
      end
    end
    describe "strip_section" do
      it "should return all values in section except given row, col index" do
        row_i = 4
        col_i = 0
        @solver.strip_section(row_i, col_i, @solution_1).should == [
        9, 1, 4,
           5, 7,
        3, 2, 6
        ]
      end
    end
  end

end
