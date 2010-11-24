module Sleuthoku
  class Board
    def self.build(data, opts = {})
      row_delim = opts[:row] || "\n"
      val_delim = opts[:val] || "\s"
      new do |base|
        base.config = data.split(row_delim).map { |row| row.split(val_delim) }.map { |row| row.map!(&:to_i) }
      end
    end

    attr_accessor :config
    def initialize
      @config = []
      if block_given?
        yield(self)
      end
    end

    def [](row)
      @config[row]
    end

  end
end