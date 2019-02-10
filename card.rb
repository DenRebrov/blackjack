class Card
  ACE_CORRECTION = 10
  SUITS = %w[♠ ♥ ♣ ♦].freeze
  RANKS = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 10,
    "Q" => 10,
    "K" => 10,
    "A" => 11
  }

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
