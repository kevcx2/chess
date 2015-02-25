require 'byebug'

class Piece
  attr_accessor :pos
  attr_reader :color, :board

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board
  end

  def moves
    []
  end

  def valid?(pos)
    validity = true
    return false if !pos.all? { |x| x.between?(0, @board.length - 1)}
    if !@board[pos].nil? #change to address colors once we add opponent
      return false if @board[pos].color == @color
    end
    true
  end

  def enemy?(pos)
    return false if @board[pos].nil?
    @color != @board[pos].color
  end

end

class SlidingPiece < Piece
  def moves

    possible_moves = []

    move_dirs.each do |pair|
      x = @pos[0]
      y = @pos[1]
      found_enemy = false
      while valid?([x + pair[0], y + pair[1]]) && !found_enemy
        x += pair[0]
        y += pair[1]
        possible_moves << [x, y]
        found_enemy = enemy?([x, y])
      end
    end
    possible_moves
  end
end

class Bishop < SlidingPiece
  def move_dirs
    [[-1, 1], [-1, -1], [1, 1], [1, -1]]
  end

  def render_piece
    return ' b ' if @color == :black
    "[b]"
  end
end

class Rook < SlidingPiece
  def move_dirs
    [[0, 1], [0, -1], [1, 0], [-1, 0]]
  end

  def render_piece
    return ' r ' if @color == :black
    "[r]"
  end
end

class Queen < SlidingPiece
  def move_dirs # turn into ONE LINER
    directions = [1, 0, -1].repeated_permutation(2).to_a
    directions.delete([0, 0])
    directions
  end

  def render_piece
    return ' Q ' if @color == :black
    "[Q]"
  end
end

class SteppingPiece < Piece
  def moves
    possible_moves = []
    x = @pos[0]
    y = @pos[1]
    move_dirs.each do |pair|
      if valid?([x + pair[0], y + pair[1]])
        possible_moves << [x + pair[0], y + pair[1]]
      end
    end
    possible_moves
  end
end

class King < SteppingPiece
  def move_dirs # turn into ONE LINER
    directions = [1, 0, -1].repeated_permutation(2).to_a
    directions.delete([0, 0])
    directions
  end

  def render_piece
    return ' K ' if @color == :black
    "[K]"
  end
end

class Knight < SteppingPiece
  def move_dirs
    [[-1, 2], [1, 2], [2, 1], [2, -1], [-2, 1], [-2, -1], [1, -2], [-1, -2]]
  end

  def render_piece
    return ' k ' if @color == :black
    "[k]"
  end
end

class Pawn < SteppingPiece
  def move_dirs
    return [[1, 0]] if @color == :black
    [[-1, 0]]
  end

  # def moves
  #   possible_moves = []
  #   x = @pos[0]
  #   y = @pos[1]
  #   move_dirs.each do |pair|
  #     if valid?([x + pair[0], y + pair[1]])
  #       possible_moves << [x + pair[0], y + pair[1]]
  #     end
  #   end
  #   possible_moves
  # end

  def render_piece
    return ' p ' if @color == :black
    "[p]"
  end
end
