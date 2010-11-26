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
      begin
        depth = 0
        @board = speculative_sudoku(@board, depth)
        if !@board.is_a?(Board) || !@board.complete?
          puts "Puzzle can't be solved"
          puts @board.rows.inspect
        end
      end
    end

    def speculative_sudoku(state, depth)
      basic_sudoku(state)
      puts depth
      depth += 1
      (0..8).each do |j|
        if state.complete?
          require "ruby-debug"; debugger
          break 
        end
        (0..8).each do |k|
          next if state[j][k] > 0
          require "ruby-debug"; debugger
          
          candidates = state.candidates(j, k)
          raise UnsolvableSudokuError if candidates.empty?
          candidates.each do |candidate|
            clone       = state.clone
            clone[j][k] = candidate
            begin
              clone = speculative_sudoku(clone, depth)
            rescue UnsolvableSudokuError
            end
            if clone.complete?
              state = clone
              break
            end
          end
        end
      end
      state
    end

    def basic_sudoku(board)
      board.changing!
      while board.changing?
        board.not_changing!
        board.rows.each_with_index do |row_values, j|
          row_values.each_with_index do |col_values, k|
            val = board[j][k]
            next if val > 0

            candidates = board.candidates(j, k)

            case candidates.size
            when 0
              raise UnsolvableSudokuError
            when 1
              board[j][k] = candidates.pop
              board.changing!
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