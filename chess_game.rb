require_relative 'chess_pieces.rb'
require_relative 'chess_board.rb'
require_relative 'errors.rb'

require 'colorize'

class Game

  attr_reader :game_board

  def initialize
    @game_board = Board.new
    @current_player = :black
  end

  def play
    while !@game_board.checkmate?(@current_player)
      @game_board.render
      puts "current player: #{@current_player}"
      check_warning
      piece_pos = select_piece
      show_valid_moves(piece_pos)
      move_to = select_destination(piece_pos)
      move_piece(piece_pos, move_to)
      switch_player

    end
    game_over
  end

  private

  def check_warning
    puts "#{@current_player} is in check!" if @game_board.check?(@current_player)
  end

  def switch_player
    @current_player == :black ? @current_player = :white : @current_player = :black
  end

  def game_over
    puts "#{switch_player} wins!"
    @game_board.render
  end

  def map_position(start = true)
    puts (start ? "select your piece" : "select your destination")
    piece_pos = gets.chomp.gsub(" ", "").split("") #["a", "4"]
    raise ArgumentError.new if piece_pos.length != 2
    raise ArgumentError.new unless piece_pos[0] =~ /[a-h]/
    raise ArgumentError.new unless piece_pos[1] =~ /[0-8]/
    Board.string_to_pos(piece_pos)
  end

  def select_piece
    begin
      piece_pos = map_position
      raise ArgumentError.new if piece_pos.length != 2 || !@game_board.has_piece?(piece_pos)
      raise NoPossibleMoveError.new if @game_board.valid_moves(piece_pos).empty?
      raise NotYourOwnPieceError.new if @game_board[piece_pos].color != @current_player
    rescue NotYourOwnPieceError
      puts "Please select your own piece"
      retry
    rescue NoPossibleMoveError
      puts "Please select a piece that has at least one possible move"
      retry
    rescue ArgumentError
      puts "Please select position with piece on it"
      retry
    end
    piece_pos
  end

  def select_destination(piece_pos)
    begin
      des = map_position(false)
      raise ArgumentError.new unless @game_board.valid_moves(piece_pos).include?(des)
    rescue ArgumentError => e
      puts "Please enter a valid destination"
      retry
    end
    des
  end

  def show_valid_moves(piece_pos)
    # puts "List of valid moves: "
      @game_board.highlight_moves_render(@game_board.valid_moves(piece_pos, true))
    # p @game_board.valid_moves(piece_pos, true).map {|move| Board.pos_to_string(move)}
  end

  def move_piece(piece, move_to)
    @game_board.move(piece, move_to)
  end

end
