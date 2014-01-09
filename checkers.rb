class Piece
  attr_accessor :position

  def initialize(initial_position, last_row)
    @state = :pawn
    @position = initial_position
    @last_row = last_row
  end

  def perform_slide(to)
    # only kings can move forward and backward,
    # but all pieces can only slide one space
    return false unless moves_forward?(to) || king?
    return false unless moves_one_space?(to)

    # set the new position, check if the piece has def reached
    # the opposite side of the board, and promote the piece to
    # king if so
    @position = to
    promote if reached_opposite_side?

    true
  end

  def perform_jump
  end

  private

    def promote
      @state = :king
    end

    def king?
      return @state == :king
    end

    def reached_opposite_side?
      @position.first == last_row
    end

    def moves_one_space?(to)
      move_diff(to).all? { |len| len.abs == 1 }
    end

    def moves_forward?(to)
      move_diff(to).first > 0
    end

    # move_diff: agnostic with respect to columns.
    # will return the # of rows and the direction,
    # but just the number of columns (not direction)
    def move_diff(to)
      [to[0] - @position[0], (to[1] - @position[1]).abs]
    end
end