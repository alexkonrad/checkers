class Piece
  #attr_writer :king
  attr_accessor :pos

  def initialize(pos)
    @king, @pos = false, pos
  end

  def perform_slide(to)
    unless king?
      return false unless move_diff(to, pos) == [1, 1]
  end

  def perform_jump
  end

  def promote?
  end

  def promote
    @king = true
  end

  def king?
    return @king
  end
end