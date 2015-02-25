require_relative 'chess_pieces.rb'
require_relative 'chess_board.rb'
require_relative 'errors.rb'

class Game
  attr_reader :game_board

  def initialize
    @game_board = Board.new
  end

  def play
    loop do
      @game_board.render
      #select piece
      piece_pos = select_piece
      #print all valid moves
      print_valid_moves(piece_pos)
      #select destination
      move_to = select_destination(piece_pos)
      #move piece/update board
      move_piece(piece_pos, move_to)
    end
  end

  def select_piece
    begin
      puts "select your piece"
      piece_pos = gets.chomp.split(" ").map(&:to_i)
      raise ArgumentError.new unless @game_board.has_piece?(piece_pos)
      raise NoPossibleMoveError.new if @game_board.valid_moves(piece_pos).empty?
    rescue NoPossibleMoveError
      p "Please select a piece that has at least one possible move"
      retry
    rescue ArgumentError
      p "Please select position with piece on it"
      retry
    end
    piece_pos
  end

  def select_destination(piece_pos)
    begin
      puts "select your destination"
      des = gets.chomp.split(" ").map(&:to_i)
      raise ArgumentError.new unless @game_board.valid_moves(piece_pos).include?(des)
    rescue ArgumentError => e
      puts "Please enter a valid destination"
      retry
    end
    des
  end

  def print_valid_moves(piece_pos)
    p "List of valid moves: "
    p @game_board.valid_moves(piece_pos)
  end

  def move_piece(piece, move_to)
    @game_board.move(piece, move_to)
  end

end
