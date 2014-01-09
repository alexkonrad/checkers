class Piece
  attr_accessor :pos

  def initialize(pos)
    @king, @pos = false, pos
  end

  def perform_slide(to)
    unless king?
      return false unless move_diff(to, pos) == [1, 1]
    else
      # king can move forward or backward
      return false unless move_diff(to, pos) == [1, 1] ||
                          move_diff(to, pos) == [-1, 1]
    end

    # set the new position, check if the piece has def reached
    # the opposite side of the board, and promote the piece to
    # king if so

    @pos = to


    true
  end

  def perform_jump
  end

  private

    def promote
      @king = true
    end

    def king?
      return @king
    end

    # opposite_side? returns true if a piece reaches the
    # last row of the opposite side of the board.
    def opposite_side?
    end

    # move_diff: agnostic with respect to columns.
    # will return the # of rows and the direction,
    # but just the number of columns (not direction)
    def move_diff(to, from)
      [to[0] - from[0], (to[1] - from[1]).abs]
    end
end