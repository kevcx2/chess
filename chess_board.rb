require 'byebug'

class Board
  BOARD_SIZE = 8
  ROWS = { "8" => 0, "7" => 1, "6" => 2, "5" => 3, "4" => 4, "3" => 5, "2" => 6, "1" => 7 }
  COLUMNS = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4, "f" => 5, "g" => 6, "h" => 7}

  attr_accessor :grid

  def initialize(dup = false)
    @dup = dup
    @grid = create_board
  end

  def self.string_to_pos(str_pos)
    [ROWS[str_pos[1]], COLUMNS[str_pos[0].downcase]]
  end

  def self.pos_to_string(pos)
     COLUMNS.keys[pos[1]] + ROWS.keys[pos[0]]
  end

  def length
    @grid.length
  end


  def [](pos)
    @grid[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    @grid[pos[0]][pos[1]] = piece
  end

  def has_piece?(pos)
    !self[pos].nil?
  end

  def valid_moves(pos, king_check_flag = true)
    self[pos].moves(king_check_flag)
  end

  def move(start, end_pos)
    piece = self[start]
    self[end_pos] = piece
    self[start] = nil
    piece.pos = end_pos

    if piece.class == Pawn
      piece.first_move
    end
  end

  def dup
    dup_board = Board.new(true)
    new_pieces = []

    @grid.flatten.compact.each do |piece|
      copy_piece = piece.class.new(piece.pos, piece.color, nil)
      dup_board[copy_piece.pos] = copy_piece
      new_pieces << copy_piece
    end

    new_pieces.each do |copy_piece|
      copy_piece.board = dup_board
    end

    dup_board
  end

  def check?(color)
    enemies = @grid.flatten.compact.select {|piece| piece.color != color}
    enemies.each do |piece|
      moves = valid_moves(piece.pos, false)
      return true if moves.include?(king_pos(color))
    end
    false
  end

  def checkmate?(color)
    if check?(color)
      own_pieces = @grid.flatten.compact.select {|piece| piece.color == color}
      own_pieces.each do |piece|
        return false if !valid_moves(piece.pos).empty?
      end
      return true
    end
    false
  end

  def render
    puts "  a  b  c  d  e  f  g  h"
    @grid.each_with_index do |row, row_idx|
      render_string = "#{8 - row_idx}"
        row.each_with_index do |col, col_idx|
        if (row_idx.even? && col_idx.even?) || (row_idx.odd? && col_idx.odd?)
          if col.nil?
            render_string += ("   ".colorize(:background => :light_blue))
          else
            render_string += (" #{col.render_piece} ".colorize(:background => :light_blue))
          end
        else
          if col.nil?
            render_string += ("   ".colorize(:background => :light_red))
          else
            render_string += (" #{col.render_piece} ".colorize(:background => :light_red))
          end
        end
      end
      puts render_string
    end
    true
  end

  def highlight_moves_render(moves)
    puts "  a  b  c  d  e  f  g  h"
    @grid.each_with_index do |row, row_idx|
      render_string = "#{8 - row_idx}"
        row.each_with_index do |col, col_idx|
        if (row_idx.even? && col_idx.even?) || (row_idx.odd? && col_idx.odd?)
          back = :light_blue
          back = :light_green if moves.include?([row_idx, col_idx])
          if col.nil?
            render_string += ("   ".colorize(:background => back))
          else
            render_string += (" #{col.render_piece} ".colorize(:background => back))
          end
        else
          back = :light_red
          back = :green if moves.include?([row_idx, col_idx])
          if col.nil?
            render_string += ("   ".colorize(:background => back))
          else
            render_string += (" #{col.render_piece} ".colorize(:background => back))
          end
        end
      end
      puts render_string
    end
    true
  end

  private

  def king_pos(color)
    @grid.flatten.compact.find {|piece| piece.is_a?(King) && piece.color == color}.pos
  end

  def create_board
    grid = Array.new(BOARD_SIZE) do |row|
    row = Array.new(8, nil)
    end

    if @dup == false
      grid[0] = black_starting_pos_row_1
      grid[1] = black_starting_pos_row_2
      grid[6] = white_starting_pos_row_6
      grid[7] = white_starting_pos_row_7
    end

    grid
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
