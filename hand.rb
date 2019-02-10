class Hand
  attr_accessor :cards

  CARDS_LIMIT = 3
  MAX_SCORE = 21

  def initialize
    @cards = []
  end

  def score
    sum ||= 0
    sum = @cards.sum(&:point)

    @cards.each do |card|
      if sum > MAX_SCORE && card.ace?
        sum -= Card::ACE_CORRECTION
      end
    end
    sum
  end

  def full?
    @cards.size == CARDS_LIMIT
  end
end
