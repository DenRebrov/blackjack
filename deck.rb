class Deck
  attr_accessor :cards

  def initialize
    @cards = create_deck
  end

  def remove_card(card)
    @cards.delete(card)
  end

  private

  def create_deck
    deck = []
    Card::SUITS.each do |suit|
      Card::RANKS.each do |rank, point|
        deck << Card.new(rank, suit, point)
      end
    end
    deck.shuffle!
  end
end
