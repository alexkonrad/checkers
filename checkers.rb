class InvalidMoveError < StandardError
end

# REV: Looks good dude! Maybe I'm reading this code easily since we worked together?

class Board
  BOARD_SIZE = 8
  WHITE_POSITIONS = [
    [0, 1], [0, 3], [0, 5], [0, 7],
    [1, 0], [1, 2], [1, 4], [1, 6],
    [2, 1], [2, 3], [2, 5], [2, 7]
  ]
  RED_POSITIONS = [
    [7, 0], [7, 2], [7, 4], [7, 6],
    [6, 1], [6, 3], [6, 5], [6, 7],
    [5, 0], [5, 2], [5, 4], [5, 6]
  ]

  def initialize(pieces = true)
    # REV: Just use BOARD_SIZE here?
    @grid = Array.new(8) { Array.new(8, nil) }

    if pieces
      WHITE_POSITIONS.each { |p| self[p] = Piece.new(p, :white, self) }
      RED_POSITIONS.each { |p| self[p] = Piece.new(p, :red, self) }
    end
  end

  def draw
    draw_grid = @grid.map do |row|
      row.map do |cell|
        token = cell ? cell.token : :_
        token.to_s
      end.join(" ")
    end.join("\n")

    print draw_grid
  end

  def find_piece(pos)
    @grid.flatten.compact.select { |i| i.position == pos }.first
  end

  def dup
    dup_board = Board.new(false)

    pieces.each do |piece|
      pos = piece.position.dup
      dup_board[pos] = Piece.new(pos, piece.color, dup_board)
    end

    dup_board
  end

  def pieces
    @grid.flatten.compact
  end

  def [](pos)
    i, j = pos
    @grid[i][j]
  end

  def []=(pos, k)
    i, j = pos
    @grid[i][j] = k
  end

  # REV: adding in a Canadian checkers feature?
  def size
    BOARD_SIZE
  end
end

class Piece
  attr_accessor :board, :position
  attr_reader :color, :token

  def initialize(initial_position, color, board)
    @position, @color, @board = initial_position, color, board

    @last_row = color == :white ? @board.size-1 : 0
    @token = color == :white ? :W : :R
    @state = :pawn
  end

  def perform_moves(move_seq)
    raise InvalidMoveError unless valid_move_seq?(move_seq)

    perform_moves!(move_seq)
  end

  def valid_move_seq?(move_seq)
    new_board = @board.dup
    new_piece = new_board.find_piece(self.position)
    new_piece.board = new_board

    begin
      new_piece.perform_moves!(move_seq)
    rescue InvalidMoveError
      false
    else
      true
    end
  end

  def perform_moves!(move_seq)
    move_seq.each do |move|
      raise InvalidMoveError unless perform_slide(move) || perform_jump(move)
    end
  end

  def perform_slide(square)
    return false unless can_move?(square) && adjacent_to?(square)

    move_to(square)
    promote if reached_opposite_side?

    true
  end

  def perform_jump(square)

    adjacent_square = [@position[0] + move_diff(square)[0]/2,
                       @position[1] + move_diff(square)[1]/2]
    other_piece = @board[adjacent_square]

    return false unless can_move?(square) && jumps_over?(other_piece)

    move_to(square)
    promote if reached_opposite_side?

    true
  end

  private

    def promote
      @state = :king
    end

    def move_to(square)
      @board[square] = self
      @board[@position] = nil
      @position = square
    end

    def can_move?(square)
      @board[square].nil? && (moves_forward_to?(square) || king?)
    end

    def king?
      @state == :king
    end

    def reached_opposite_side?
      @position.first == @last_row
    end

    def adjacent_to?(pos)
      move_diff(pos).all? { |len| len.abs == 1 }
    end

    def moves_forward_to?(pos)
      dir = move_diff(pos).first
      p dir
      color == :white ? dir > 0 : dir < 0
    end

    def jumps_over?(piece)
      piece && adjacent_to?(piece.position) && @color != piece.color
    end

    def move_diff(pos)
      [pos[0] - @position[0], pos[1] - @position[1]]
    end
end