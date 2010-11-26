  RANGE = (1..9)
module Sleuthoku

  class UnsolvableSudokuError < Exception
  end

  class ViolatedSudokuError < Exception
  end

  class Solver
    def self.solve(board)
      solver = new(board)
      solver.solve!
      solver.solution
    end


    attr_accessor :solution, :board, :data, :changing
    def initialize(data)
      @data     = data
      @board    = Board.build(data)
    end

    def solve!
      @board = solve_board(@board)
    end

    def solve_board(b)
      board = b.copy
      board = basic_sudoku(board)
      return board if board.complete?

        (0..8).each do |j|
          (0..8).each do |k|
            next if board[j][k] > 0
            candidates = board.candidates(j, k)

            candidates.each do |candidate|
              clone  = board.copy
              clone[j][k] = candidate

              begin
                clone = solve_board(clone)
              rescue UnsolvableSudokuError
                next
              end

              if clone.complete?
                board = clone
              end
            end
          end
        end
      board
    end

    def basic_sudoku(board)
      board.changing!
      while board.changing?
        board.not_changing!
        (0..8).each do |j|
          (0..8).each do |k|
            val = board[j][k]
            next if val > 0

            candidates = board.candidates(j, k)
            case candidates.size
            when 0
              raise UnsolvableSudokuError
            when 1
              board[j][k] = candidates.pop
              board.changing!
              next
            end

          end
        end
      end
      board
    end

    def solution
      @board.rows
    end
  end
end