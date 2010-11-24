module Sleuthoku
  class Solver
    def self.solve(board)
      solver = new(board)
      solver.solve!
      solver.solution
    end

    attr_reader :solution
    def initialize(board)
      @board = board
      @solution = board.clone
      @universe   = get_universe
    end

    def solve!
      while @solution.any? { |row| row.any? { |val| val < 1 } } do
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
            end
          end
        end
        # puts @solution.map { |row| row.join(" ") }.join("\n") + "\n"
      end
      @solution
    end

    def section(row_index, col_index)
      [].tap do |s|
        3.times do |l|
          3.times do |m|
            s << @solution[((row_index / 3) * 3) + l][((col_index / 3) * 3) + m]
          end
        end
      end
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