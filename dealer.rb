class Dealer < Player
  def initialize
    @bank = BANK
    @hand = Hand.new
  end

  def close_cards
    @hand.cards.each { |card| card.type = :closed }
  end
end
