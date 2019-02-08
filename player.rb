class Player
  BANK = 100

  attr_reader :name, :cards
  attr_accessor :bank

  def initialize(name)
    @name = name
    @bank = BANK
    @cards = []
  end

  def get_card(card)
    @cards << card
  end

  def remove_cards
    cards_for_deck = []
    cards_for_deck += @cards
    @cards = []
    cards_for_deck
  end

  def open_cards
    @cards.each { |card| card.type = :open }
  end

  def score
    sum ||= 0
    @cards.each do |card|
      if card.ace?
        sum + card.point > 21 ? sum += 1 : sum += card.point
      else
        sum += card.point
      end
    end
    sum
  end

  def full_hand?
    @cards.size == 3
  end

  def get_prize(amount)
    @bank += amount
  end

  def lose_bet(bet)
    @bank -= bet
    @bank = 0 if bet < 0
  end
end
