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

    RANGE = (1..9)

    attr_accessor :solution, :board, :data, :changing
    def initialize(data)
      @data     = data
      @board    = Board.build(data)
    end

    def solve!
      basic_sudoku
    end

    def changing!
      @changing = true
    end

    def not_changing!
      @changing = false
    end

    def changing?
      @changing
    end
    
    def solution
      @board.rows
    end

    def basic_sudoku
      changing!
      while changing?
        not_changing!
        @board.rows.each_with_index do |row_values, j|
          row_values.each_with_index do |col_values, k|
            val = @board[j][k]

            row = strip_row(k, @board[j])
            col = strip_col(j, k, @board.rows)
            sec = strip_section(j, k, @board.rows)

            family    = row + col + sec
            candiates = RANGE.to_a - family
            
            if val > 0
              raise ViolatedSudokuError if family.include? val
            else
              case candiates.size
              when 0
                raise UnsolvableSudokuError
              when 1
                @board[j][k] = candiates.pop
                changing!
              end
            end
          end
        end
      end
    end

    def strip_row(col_i, row)
      clone = row.clone
      clone.delete_at(col_i)
      clone
    end

    def strip_col(row_i, col_i, rows)
      col = rows.map { |r| r[col_i] }
      col.delete_at(row_i)
      col
    end

    def strip_section(row_i, col_i, rows)
      sec = [].tap do |s|
        3.times do |l|
          3.times do |m|
            s << rows[((row_i / 3) * 3) + l][((col_i / 3) * 3) + m]
          end
        end
      end
      sec -= [sec[((row_i % 3) * 3) + (col_i % 3)]]
      sec
    end

    def solve_1!
      while @solution.any? { |row| row.any? { |val| val < 1 } } do
        improved = false
        @solution.each_with_index do |row, j|
          row.each_with_index do |val, k|
            if val > 0
              @universe[j][k] = [val]
              next
            end

            cols = @solution.map { |r| r[k] }
            sect = section(j, k)

            @universe[j][k] = @universe[j][k] - row - cols - sect

            if @universe[j][k].size == 1
              @solution[j][k] = @universe[j][k].first
              improved = true
              break
            end

            if @universe[j][k].size == 0
              raise UnsolvableSudokuError
            end

          end
        end
        # puts @solution.map { |row| row.join(" ") }.join("\n") + "\n"
        if !improved
          break
        end
      end
      @solution
    end

    def section(row_index, col_index, set = @solution)
    end

    def get_universe
      [].tap do |all|
        9.times do
          all << [].tap do |row|
            9.times do |j|
              row[j] = []
              9.times do |k|
                row[j][k] = k + 1
              end
            end
          end
        end
      end
    end

  end
end