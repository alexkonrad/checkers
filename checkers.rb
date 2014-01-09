class Piece
  attr_reader :position, :color

  def initialize(initial_position, color)
    @position, @color = initial_position, color

    @last_row = color == :white ? 7 : 0
    @state = :pawn
  end

  def perform_slide(square)

    return false unless moves_forward_to?(square) || king?
    return false unless adjacent_to?(square)

    @position = square
    promote if reached_opposite_side?

    true
  end

  def perform_jump(other_piece)

    return false unless jumps_over?(other_piece)
    return false unless moves_forward_to?(other_piece.position) || king?

    jump_over(other_piece)
    promote if reached_opposite_side?

    nil
  end

  private

    def jump_over(other_piece)
      diff = move_diff(other_piece.position)

      @position[0] = other_piece.position[0] + diff[0]
      @position[1] = other_piece.position[1] + diff[1]
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