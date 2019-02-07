class Dealer < Player
  def initialize
    @bank = BANK
    @cards = []
  end

  def close_cards
    @cards.each { |card| card.type = :closed }
  end
end
