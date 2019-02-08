class Deck
SIUTS = %w[♠ ♥ ♣ ♦].freeze
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

  attr_accessor :cards

  def initialize
    @cards = create_deck
  end

  def remove_card(card)
    @cards.delete(card)
  end

  def add_cards(cards)
    @cards += cards
  end

  private

  def create_deck
    deck = []
    SIUTS.each do |suit|
      RANKS.each do |rank, point|
        deck << Card.new(rank, suit, point)
      end
    end
    deck.shuffle!
  end
end
