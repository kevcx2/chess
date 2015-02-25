class Test

  def initialize

    @board = [[1,2,3],
              [4,5,6]]
  end

  def [](pos)
    @board[pos[0]][pos[1]]
  end

  def []=(pos, thing)
    @board[pos[0]][pos[1]] = thing
  end

end
