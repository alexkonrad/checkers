class InvalidMoveError < StandardError

class Piece
  attr_reader :position, :color

  def initialize(initial_position, color)
    @position, @color = initial_position, color

    @last_row = color == :white ? 7 : 0
    @state = :pawn
  end

  def valid_move_seq?(move_seq)
    new_board = @board.dup
    new_piece = self.dup
    new_piece.board = new_board

    begin
      new_piece.perform_moves!(move_seq)
    rescue InvalidMoveError
      return false
    end

    true
  end

  def perform_moves!(move_seq)
    move_seq.each do |move|
      unless perform_slide(move) || perform_jump(move)
        raise InvalidMoveError.new "#{move}"
      end
    end
  end

  def perform_slide(square)

    return false unless moves_forward_to?(square) || king?
    return false unless adjacent_to?(square)

    @position = square
    promote if reached_opposite_side?

    true
  end

  def perform_jump(square)
    other_piece = @board[move_diff(square) / 2]

    return false unless jumps_over?(other_piece)
    return false unless moves_forward_to?(square) || king?

    jump_to(square)
    promote if reached_opposite_side?

    true
  end

  private

    def jump_to(square)
      diff = move_diff(square)

      @position[0] += diff[0]
      @position[1] += diff[1]
    end

    def promote
      @state = :king
    end

    def king?
      @state == :king
    end

    def reached_opposite_side?
      @position.first == last_row
    end

    def adjacent_to?(pos)
      move_diff(pos).all? { |len| len.abs == 1 }
    end

    def moves_forward_to?(pos)
      dir = move_diff(pos).first

      color == :white ? dir > 0 : dir < 0
    end

    def jumps_over?(piece)
      adjacent_to?(piece.position) && @color != piece.color
    end

    def move_diff(pos)
      [pos[0] - @position[0], pos[1] - @position[1]]
    end
end