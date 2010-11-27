module Sudoku
  class Board
    def self.build(data, opts = {})
      row_delim = opts[:row] || "\n"
      val_delim = opts[:val] || "\s"
      new do |base|
        base.rows = data.split(row_delim).map { |row| row.split(val_delim) }.map { |row| row.map!(&:to_i) }
      end
    end

    attr_accessor :rows
    def initialize
      @rows = []
      yield(self) if block_given?
    end
    
    def copy
      new_board = clone
      new_board.rows = rows.map { |row| row.clone }
      new_board
    end

    def [](row)
      @rows[row]
    end

    def complete?
      !rows.empty? &&
      rows.all? { |row| row.sort == RANGE.to_a } &&
      columns.all? { |col| col.sort == RANGE.to_a } &&
      sections.all? { |sect| sect.sort == RANGE.to_a }
    end
    
    def columns
      [].tap do |cols|
        INDICES.each do |j|
          col = []
          INDICES.each do |k|
            col << rows[k][j]
          end
          cols << col
        end
      end
    end
    
    def sections
      [].tap do |sects|
        (0..2).each do |j|
          (0..2).each do |k|
            sect = []
            (0..2).each do |l|
              (0..2).each do |m|
                sect << rows[(j * 3) + l][(k * 3) + m]
              end
            end
            sects << sect
          end
        end
      end
    end

    def candidates(row_i, col_i)
      row = strip_row row_i, col_i
      col = strip_col row_i, col_i
      sec = strip_section row_i, col_i

      family    = row + col + sec
      RANGE.to_a - family
    end

    def strip_row(row_i, col_i)
      clone = rows[row_i].clone
      clone.delete_at(col_i)
      clone
    end

    def strip_col(row_i, col_i)
      col = rows.map { |r| r[col_i] }
      col.delete_at(row_i)
      col
    end

    def strip_section(row_i, col_i)
      sec = [].tap do |s|
        3.times do |l|
          3.times do |m|
            s << rows[((row_i / 3) * 3) + l][((col_i / 3) * 3) + m]
          end
        end
      end
      sec_i = ((row_i % 3) * 3) + (col_i % 3)
      sec.delete_at(sec_i)
      sec
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

  end
end