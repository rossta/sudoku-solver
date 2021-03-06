require "rubygems"

%w[ board solver ].each do |file|
  require "sudoku/#{file}"
end

module Sudoku
  CONFIG_1 = <<-TXT
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

  CONFIG_2 = <<-TXT
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
  
  CONFIG_3 = <<-TXT
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
end
