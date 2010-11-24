require 'spec_helper'

describe Sleuthoku::Solver do
  before(:each) do
    @board_1 = [
      [7, 0, 5, 0, 0, 0, 2, 9, 4],
      [0, 0, 1, 2, 0, 6, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0, 0, 7],
      [9, 0, 4, 5, 0, 0, 0, 2, 0],
      [0, 0, 7, 3, 6, 2, 1, 0, 0],
      [0, 2, 0, 0, 0, 1, 7, 0, 8],
      [1, 0, 0, 0, 9, 0, 0, 0, 0],
      [0, 0, 0, 7, 0, 5, 9, 0, 0],
      [5, 3, 9, 0, 0, 0, 8, 0, 2]
    ]

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
    
    @solver = Sleuthoku::Solver.new(@board_1)
  end
  describe "self.solve" do
    it "should fill in missing values for board" do
      solution = Sleuthoku::Solver.solve(@board_1)
      solution.should == @solution_1
    end
  end
  
  describe "section" do
    it "should return array of values in section for given val" do
      # center
      row = 4
      col = 4
      @solver.section(row, col).should == [5, 0, 0, 3, 6, 2, 0, 0, 1]
    end
  end
end
