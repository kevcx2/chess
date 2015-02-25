

class Board
  BOARD_SIZE = 8
  # black_start = [ Rook.new([0, 0], :black, self),
  #                 Knight.new([0, 1], :black, self),
  #                 Bishop.new([0, 2], :black, self),
  #                 King.new([0, 3], :black, self),
  #                 Queen.new([0, 4], :black, self),
  #                 Bishop.new([0, 5], :black, self),
  #                 Knight.new([0, 6], :black, self),
  #                 Rook.new([0, 7], :black, self) ]

  attr_reader :grid

  def initialize
    @grid = create_board
  end

  def length
    @grid.length
  end

  def create_board

    grid = Array.new(BOARD_SIZE) do |row|
    row = Array.new(8, nil)
    end
    grid[0] = black_starting_pos_row_1
    grid[1] = black_starting_pos_row_2
    grid[6] = white_starting_pos_row_6
    grid[7] = white_starting_pos_row_7
    grid
  end

  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def render
    @grid.each do |row|
      render_string = ''
        row.each do |col|
        if col.nil?
          render_string << "  _  "
        else
          render_string << " #{col.render_piece} "
        end
      end
      puts render_string
    end
    true
  end

  def has_piece?(pos)
    !self[pos].nil?
  end

  def valid_moves(pos)
    self[pos].moves
  end

  def move(start, end_pos)
    piece = self[start]
    self[end_pos] = piece
    self[start] = nil
    piece.pos = end_pos
  end

  def black_starting_pos_row_1
  [ Rook.new([0, 0], :black, self),
    Knight.new([0, 1], :black, self),
    Bishop.new([0, 2], :black, self),
    King.new([0, 3], :black, self),
    Queen.new([0, 4], :black, self),
    Bishop.new([0, 5], :black, self),
    Knight.new([0, 6], :black, self),
    Rook.new([0, 7], :black, self) ]
  end

  def black_starting_pos_row_2
  [ Pawn.new([1, 0], :black, self),
    Pawn.new([1, 1], :black, self),
    Pawn.new([1, 2], :black, self),
    Pawn.new([1, 3], :black, self),
    Pawn.new([1, 4], :black, self),
    Pawn.new([1, 5], :black, self),
    Pawn.new([1, 6], :black, self),
    Pawn.new([1, 7], :black, self) ]
  end

  def white_starting_pos_row_7
  [ Rook.new([7, 0], :white, self),
    Knight.new([7, 1], :white, self),
    Bishop.new([7, 2], :white, self),
    King.new([7, 3], :white, self),
    Queen.new([7, 4], :white, self),
    Bishop.new([7, 5], :white, self),
    Knight.new([7, 6], :white, self),
    Rook.new([7, 7], :white, self) ]
  end

  def white_starting_pos_row_6
  [ Pawn.new([6, 0], :white, self),
    Pawn.new([6, 1], :white, self),
    Pawn.new([6, 2], :white, self),
    Pawn.new([6, 3], :white, self),
    Pawn.new([6, 4], :white, self),
    Pawn.new([6, 5], :white, self),
    Pawn.new([6, 6], :white, self),
    Pawn.new([6, 7], :white, self) ]
  end

end
