class Hand
  attr_accessor :cards

  CARDS_LIMIT = 3
  MAX_SCORE = 21

  def initialize
    @cards = []
  end

  def score
    sum ||= 0
    @cards.each { |card| sum += card.point }

    @cards.each do |card|
      if sum > MAX_SCORE && card.ace?
        sum -= 10
      end
    end
    sum
  end

  def full?
    @cards.size == CARDS_LIMIT
  end
end
