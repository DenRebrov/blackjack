class Hand
  attr_accessor :cards

  CARDS_LIMIT = 3
  MAX_SCORE = 21

  def initialize
    @cards = []
  end

  def score
    sum ||= 0
    @cards.each do |card|
      if card.ace?
        sum + card.point > MAX_SCORE ? sum += 1 : sum += card.point
      else
        sum += card.point
      end
    end
    sum
  end

  def full?
    @cards.size == CARDS_LIMIT
  end
end
