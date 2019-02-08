class Card
  attr_reader :rank, :suit, :point
  attr_accessor :type

  def initialize(rank, suit, point, type = :closed)
    @rank = rank
    @suit = suit
    @point = point
    @type = type
  end

  def ace?
    @point == 11
  end
end
